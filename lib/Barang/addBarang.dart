import 'package:ecashier/Barang/kelolaBarang.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter login UI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: TambahBarangPage(),
        ));
  }
}

class TambahBarangPage extends StatefulWidget {
  @override
  _TambahBarangPageState createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  var selectedKategori;
  var selectedSatuan;
  var selectedSupplier;
  String outputValidasi = "Nama Barang Sudah Terdaftar";

  bool sama;
  TextEditingController namaBarang = TextEditingController();
  TextEditingController katBarang = TextEditingController();
  TextEditingController hjBarang = TextEditingController();
  TextEditingController hbBarang = TextEditingController();
  TextEditingController jmlStok = TextEditingController();
  TextEditingController satuan = TextEditingController();
  TextEditingController minStok = TextEditingController();
  TextEditingController namaSupplier = TextEditingController();
  TextEditingController leadTime = TextEditingController();


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ignore: missing_return
  Future<bool> cek(String value) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    final QuerySnapshot result = await Firestore.instance
        .collection('barang')
        .where('namaBarang', isEqualTo: value)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length >= 1) {
      await setState(() {
        sama = true;
      });
    } else {
      Firestore.instance.collection("barang").document(namaBarang.text).setData({
        'namaBarang': namaBarang.text,
        'kategoriBarang': selectedKategori,
        'namaSupplier' : selectedSupplier,
        'hjBarang': hjBarang.text,
        'hbBarang': hbBarang.text,
        'jmlStok': jmlStok.text,
        'satuan': selectedSatuan,
        'minStok': minStok.text,
        'waktu' : formattedDate,
        'leadTime' : leadTime.text
      });

      namaBarang.text = '';

      await setState(() {
        sama = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Tambah Produk'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SizedBox.fromSize(
                    size: Size(1500, 50), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.green,
                        borderOnForeground: true, // button color
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Produk",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Nama Barang'),

                    controller: namaBarang,
                    validator: (namaBarang) {
                      if (namaBarang == null || namaBarang.isEmpty) {
                        return 'Masukan Nama Barang';
                      } else {
                        cek(namaBarang);
                        if (sama == true) {
                          return outputValidasi;
                        } else if (sama == false) {
                          setState(() {
                            namaBarang = '';
                          });
                          return null;
                        }
                      }
                      return null;
                    },
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('kategori').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Tidak bisa mendapatkan data");
                      } else {
                        List<DropdownMenuItem> kategoriItems = [];
                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
                          DocumentSnapshot snap = snapshot.data.documents[i];
                          kategoriItems.add(DropdownMenuItem(
                            child: Text(
                              snap.data['namaKategori'],
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.data['namaKategori']}",
                          ));
                        }
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Kategori Barang'),
                              value: selectedKategori,
                              items: kategoriItems,
                              validator: (value) {
                          if (value == null || value.isEmpty) {
                          return 'Kategori Barang Wajib Diisi';
                          }
                          return null;
                          },
                              onChanged: (kategoriValue) {
                                setState(() {
                                  selectedKategori = kategoriValue;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Harga Jual Barang',
                    ),
                    inputFormatters: [CurrencyTextInputFormatter(
                      locale: 'id',
                      decimalDigits: 0,
                      symbol: 'Rp'
                    )],

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga Jual Wajib Diisi';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,

                    controller: hjBarang,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Harga Beli Barang'),
                    keyboardType: TextInputType.number,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga Beli Wajib Diisi';
                      }
                      return null;
                    },
                    inputFormatters: [CurrencyTextInputFormatter(
                        locale: 'id',
                        decimalDigits: 0,
                        symbol: 'Rp'
                    )],
                    controller: hbBarang,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Jumlah Stok'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: jmlStok,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Stok Barang Wajib Diisi';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    textCapitalization:
                    TextCapitalization.words,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Waktu Pemesanan',
                    ),
                    controller: leadTime,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                // StreamBuilder<QuerySnapshot>(
                //     stream: Firestore.instance.collection('satuan').snapshots(),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) {
                //         return Text("Tidak bisa mendapatkan data");
                //       } else {
                //         List<DropdownMenuItem> satuanItems = [];
                //         for (int i = 0;
                //             i < snapshot.data.documents.length;
                //             i++) {
                //           DocumentSnapshot snap = snapshot.data.documents[i];
                //           satuanItems.add(DropdownMenuItem(
                //             child: Text(
                //               snap.documentID,
                //               style: TextStyle(color: Colors.black),
                //             ),
                //             value: "${snap.documentID}",
                //           ));
                //         }
                //         return Container(
                //
                //           child: Padding(
                //             padding: EdgeInsets.symmetric(
                //                 vertical: 10, horizontal: 5),
                //             child: DropdownButtonFormField(
                //               decoration: InputDecoration(
                //                   border: OutlineInputBorder(),
                //                   labelText: 'Satuan Barang'),
                //               value: selectedSatuan,
                //               items: satuanItems,
                //               validator: (value) {
                //                 if (value == null || value.isEmpty) {
                //                   return 'Satuan Barang Wajib Diisi';
                //                 }
                //                 return null;
                //               },
                //               onChanged: (satuanValue) {
                //                 setState(() {
                //                   selectedSatuan = satuanValue;
                //                 });
                //               },
                //             ),
                //           ),
                //         );
                //       }
                //     }),

                StreamBuilder<QuerySnapshot>(
                    stream:
                    Firestore.instance.collection('supplier').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Tidak bisa mendapatkan data");
                      } else {
                        List<DropdownMenuItem> supplierItems = [];
                        for (int i = 0;
                        i < snapshot.data.documents.length; i++) {
                          DocumentSnapshot snap = snapshot.data.documents[i];
                          supplierItems.add(DropdownMenuItem(
                            child: Text(
                              snap.data['namaSupplier'],
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.data['namaSupplier']}",
                          ));
                        }
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Supplier Barang'),
                              value: selectedSupplier,
                              items: supplierItems,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Supplier Barang Wajib Diisi';
                                }
                                return null;
                              },
                              onChanged: (supplierValue) {
                                setState(() {
                                  selectedSupplier = supplierValue;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: RaisedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KelolaBarangPage(),
                          ),
                        );
                      }
                    },
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

