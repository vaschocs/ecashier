import 'package:ecashier/Barang/kelolaBarang.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String outputValidasi = "Nama Barang Sudah Terdaftar";
  var selectedSatuan;
  bool sama;
  TextEditingController namaBarang = TextEditingController();
  TextEditingController katBarang = TextEditingController();
  TextEditingController hjBarang = TextEditingController();
  TextEditingController hbBarang = TextEditingController();
  TextEditingController jmlStok = TextEditingController();
  TextEditingController satuan = TextEditingController();
  TextEditingController minStok = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<bool> cek(String value) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('barang')
        .where('namaBarang', isEqualTo: namaBarang.text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length >= 1) {
      await setState(() {
        sama = true;
      });
    } else {
      Firestore.instance.collection("barang").document(value).setData({
        'namaBarang': namaBarang.text,
        'kategoriBarang': selectedKategori,
        'hjBarang': hjBarang.text,
        'hbBarang': hbBarang.text,
        'jmlStok': jmlStok.text,
        'satuan': selectedSatuan,
        'minStok': minStok.text,
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
                    size: Size(400, 30), // button width and height
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
                                  fontSize: 20,
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
                    autofocus: true,
                    controller: namaBarang,
                    validator: (namaBarang) {
                      if (namaBarang == null || namaBarang.isEmpty) {
                        return 'Masukan Nama Kategori';
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
                              snap.documentID,
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.documentID}",
                          ));
                        }
                        return Container(
                          width: 400.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
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
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga Jual Wajib Diisi';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: hbBarang,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SizedBox.fromSize(
                    size: Size(400, 30), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.green,
                        borderOnForeground: true, // button color
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Stok",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('satuan').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Tidak bisa mendapatkan data");
                      } else {
                        List<DropdownMenuItem> satuanItems = [];
                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
                          DocumentSnapshot snap = snapshot.data.documents[i];
                          satuanItems.add(DropdownMenuItem(
                            child: Text(
                              snap.documentID,
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.documentID}",
                          ));
                        }
                        return Container(
                          width: 400.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Satuan Barang'),
                              value: selectedSatuan,
                              items: satuanItems,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Satuan Barang Wajib Diisi';
                                }
                                return null;
                              },
                              onChanged: (satuanValue) {
                                setState(() {
                                  selectedSatuan = satuanValue;
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
                        labelText: 'Minimum Stok'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: minStok,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Minimum Stok wajib diisi';
                      }
                      return null;
                    },
                  ),
                ),
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
