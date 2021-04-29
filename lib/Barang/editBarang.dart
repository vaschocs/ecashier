
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';

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
      this.satuan,
      this.index});


  final String namaBarang;
  final String katBarang;
  final String hjBarang;
  final String hbBarang;
  final String jmlStok;
  final String minStok;
  final index;
  final String satuan;
  @override
  _EditBarangPageState createState() => _EditBarangPageState();
}

class _EditBarangPageState extends State<EditBarangPage> {
  var selectedKategori;
  var selectedSatuan;
  var indeks;

  TextEditingController controllerNama;
  TextEditingController controllerHj;
  TextEditingController controllerHb;
  TextEditingController controllerjmlStok;
  TextEditingController controllerminStok;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // void updateBarang(List<DocumentSnapshot> documents, indeks) async {
  //   if (documents.length >= 1) {
  //     final snackBar = SnackBar(content: Text('Nama Barang Sudah Terdaftar'));
  //     ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
  //   } else {
  //     Firestore.instance.runTransaction((Transaction transaction) async {
  //       DocumentSnapshot snapshot = await transaction.get(indeks);
  //       await transaction.update(snapshot.reference, {
  //         "namaBarang": controllerNama,
  //       });
  //     });
  //   }
  // }
  //
  //
  // Future<bool> doesNameAlreadyExist() async {
  //   final QuerySnapshot result = await Firestore.instance
  //       .collection('barang')
  //       .where('namaBarang', isEqualTo: controllerNama.text)
  //       .limit(1)
  //       .getDocuments();
  //   final List<DocumentSnapshot> documents = result.documents;
  //   updateBarang(documents, indeks);
  // }

  @override
  void initState() {
    super.initState();
    controllerNama = new TextEditingController(text: widget.namaBarang);
    controllerHj = new TextEditingController(text: widget.hjBarang);
    controllerHb = new TextEditingController(text: widget.hbBarang);
    controllerjmlStok = new TextEditingController(text: widget.jmlStok);
    controllerminStok = new TextEditingController(text: widget.minStok);
    selectedKategori = widget.katBarang;
    selectedSatuan = widget.satuan;
    indeks = widget.index;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Edit Produk'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        key: _formKey,
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
                  controller: controllerNama,
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //                     //   return 'Masukan Nama Kategori Baru';
                    //                     // } else {
                    //                     //   cek(value, konteksAdd);
                    //                     //   if (sama) {
                    //                     //     return outputValidasi;
                    //                     //   } else if (!sama) {
                    //                     //     setState(() {
                    //                     //       value = '';
                    //                     //     });
                    //                     //     return null;
                    //                     //   }
                    //                     // }
                    //                     // return null;
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('kategori').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Tidak bisa mendapatkan data");
                    } else {
                      List<DropdownMenuItem> kategoriItems = [];
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
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
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controllerHj,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Harga Beli Barang'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controllerHb,
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
                  controller: controllerjmlStok,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('satuan').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Tidak bisa mendapatkan data");
                    } else {
                      List<DropdownMenuItem> satuanItems = [];
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
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
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      border: OutlineInputBorder(), labelText: 'Minimum Stok'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controllerminStok,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: RaisedButton(
                  onPressed: () async {
                    // await doesNameAlreadyExist();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => KelolaBarangPage(),
                    //   ),
                    // );
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
    );
  }
}
