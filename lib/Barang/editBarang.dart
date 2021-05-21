import 'package:ecashier/Barang/kelolaBarang.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:ecashier/Barang/produk.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());
BuildContext konteks;

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
          body: EditBarangPage(),
        ));
  }
}

class EditBarangPage extends StatefulWidget {
  EditBarangPage(
      {this.namaBarang,
      this.katBarang,
      this.hjBarang,
      this.hbBarang,
      this.jmlStok,
      this.minStok,
      this.namaSupplier,
      this.satuan,
        this.leadTime,
      this.index});

  final String namaBarang;
  final String katBarang;
  final String hjBarang;
  final String hbBarang;
  final String jmlStok;
  final String minStok;
  final index;
  final String leadTime;
  final String satuan;
  final String namaSupplier;
  @override
  _EditBarangPageState createState() => _EditBarangPageState();
}

class _EditBarangPageState extends State<EditBarangPage> {
  var selectedKategori;
  var selectedSatuan;
  var selectedSupplier;
  var index;

  TextEditingController controllerNama;
  TextEditingController controllerHj;
  TextEditingController controllerHb;
  TextEditingController controllerjmlStok;
  TextEditingController controllerminStok;
TextEditingController controllerLeadTime;
  final _formKey = GlobalKey<FormState>();
  bool jawaban;
  bool hasil;
  bool hasilnya;
  String outputValidasi = "Nama Barang Sudah Terdaftar";

  @override
  void initState() {
    super.initState();
    controllerNama = new TextEditingController(text: widget.namaBarang);
    controllerHj = new TextEditingController(text: widget.hjBarang);
    controllerHb = new TextEditingController(text: widget.hbBarang);
    controllerjmlStok = new TextEditingController(text: widget.jmlStok);
    controllerminStok = new TextEditingController(text: widget.minStok);
    selectedKategori = widget.katBarang;
    selectedSupplier = widget.namaSupplier;
    selectedSatuan = widget.satuan;
    index = widget.index;
    controllerLeadTime = new TextEditingController(text: widget.leadTime);
  }

  Future<bool> deleteBarang(
      DocumentReference index, BuildContext deleteKonteks) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(index);
      await transaction.delete(snapshot.reference);

      await Navigator.of(deleteKonteks).pop();

      jawaban = true;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new KelolaBarangPage(),
        ));
  }

  Future<bool> update(DocumentReference index, String value) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    final QuerySnapshot result = await Firestore.instance
        .collection('barang')
        .where('namaBarang', isEqualTo: value)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length >= 1) {
      hasil = true;
    } else {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(snapshot.reference, {
          'namaBarang': value,
          'kategoriBarang': selectedKategori,
          'namaSupplier': selectedSupplier,
          'hjBarang': controllerHj.text,
          'hbBarang': controllerHb.text,
          'jmlStok': controllerjmlStok.text,
          'satuan': selectedSatuan,
          'minStok': controllerminStok.text,
          'waktu': formattedDate,
        });
      });
      hasil = false;
    }

    return null;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Edit Produk'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                      border: OutlineInputBorder(),
                      labelText: 'Nama Barang',
                    ),
                    controller: controllerNama,
                    validator: (controllerNama) {
                      update(index, controllerNama);
                      print('JAWABAN' + hasil.toString());
                      if (controllerNama == null || controllerNama.isEmpty) {
                        return 'Masukan Nama Barang Baru';
                      } else if (hasil == true) {
                        return outputValidasi;
                      } else if (hasil == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KelolaBarangPage(),
                          ),
                        );
                      } else {
                        return null;
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'id', decimalDigits: 0, symbol: 'Rp')
                      ],
                      controller: controllerHj,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga Jual Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Harga Beli Barang'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'id', decimalDigits: 0, symbol: 'Rp')
                      ],
                      controller: controllerHb,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga Beli Wajib Diisi';
                        }
                        return null;
                      }),
                ),
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
                              "Stok",
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
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Jumlah Stok'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: controllerjmlStok,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah Stok Wajib Diisi';
                        }
                        return null;
                      }),
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Satuan Barang'),
                              value: selectedSatuan,
                              items: satuanItems,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Satuan barang wajib diisi';
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
                      controller: controllerminStok,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Minimal Stok  Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('supplier').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Tidak bisa mendapatkan data");
                      } else {
                        List<DropdownMenuItem> supplierItems = [];
                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
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
                      if (_formKey.currentState.validate()) ;
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
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: RaisedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext deleteKonteks) {
                            return AlertDialog(
                              content: Stack(
                                // ignore: deprecated_member_use
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Apakah benar anda ingin menghapus barang" +
                                              ' ' +
                                              controllerNama.text +
                                              "?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 50,
                                                width: 180,
                                                child: RaisedButton(
                                                  color: Colors.green,
                                                  child: Text(
                                                    "Hapus",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30,
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    deleteBarang(
                                                        index, deleteKonteks);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 50,
                                                width: 180,
                                                child: RaisedButton(
                                                  child: Text("Batal",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30,
                                                          color: Colors.black)),
                                                  onPressed: () {
                                                    Navigator.of(deleteKonteks)
                                                        .pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    color: Colors.redAccent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Hapus',
                            style: TextStyle(
                              fontSize: 30,
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
