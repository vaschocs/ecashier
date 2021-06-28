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
        title: 'Edit Barang Tanpa Nama',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: TanpaNamaPage(),
        ));
  }
}

class TanpaNamaPage extends StatefulWidget {
  TanpaNamaPage(
      {this.namaBarang,
      this.katBarang,
      this.hjBarang,
      this.hbBarang,
      this.jmlStok,
      this.minStok,
      this.namaSupplier,
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
  final String namaSupplier;
  @override
  TanpaNamaPageState createState() => TanpaNamaPageState();
}

class TanpaNamaPageState extends State<TanpaNamaPage> {
  var selectedKategori;
  var selectedSupplier;
  var indeks;

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
    indeks = widget.index;
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
  }

  Future<bool> update() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('barang')
        .where('namaBarang', isEqualTo: controllerNama.text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> document = result.documents;

    hasil = false;

    return null;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Edit Produk'),
        backgroundColor: Colors.blue,
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
                        color: Colors.blue,
                        borderOnForeground: true, // button color
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Edit Produk",
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
                    enabled: false,
                    controller: controllerNama,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: RaisedButton(
                        onPressed: () async {
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now);
                          if (_formKey.currentState.validate()) {
                            Firestore.instance.runTransaction(
                                (Transaction transaction) async {
                              DocumentSnapshot snapshot =
                                  await transaction.get(indeks);
                              await transaction.update(snapshot.reference, {
                                'namaBarang': controllerNama.text,
                                'kategoriBarang': selectedKategori,
                                'namaSupplier': selectedSupplier,
                                'hjBarang': controllerHj.text,
                                'hbBarang': controllerHb.text,
                                'jmlStok': controllerjmlStok.text,
                                'minStok': controllerminStok.text,
                                'waktu': formattedDate,
                              });
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext editKonteks) {
                                  return AlertDialog(
                                    content: Stack(
                                      // ignore: deprecated_member_use
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Apakah benar anda ingin melakukan update data barang?",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 180,
                                                      child: RaisedButton(
                                                        color: Colors.blue,
                                                        child: Text(
                                                          "Ya",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                                  editKonteks)
                                                              .pop();
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    ProdukPage(

                                                                    ),
                                                              ));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 180,
                                                      child: RaisedButton(
                                                        color: Colors.red,
                                                        child: Text(
                                                          "Tidak",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                                  editKonteks)
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
                          }
                          ;
                        },
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Simpan',
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 180,
                                                    child: RaisedButton(
                                                      color: Colors.red,
                                                      child: Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        deleteBarang(indeks,
                                                            deleteKonteks);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => new ProdukPage(),
                                                            ));
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
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .black)),
                                                      onPressed: () {
                                                        Navigator.of(
                                                                deleteKonteks)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
