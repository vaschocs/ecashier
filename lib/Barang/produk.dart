import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:ecashier/Barang/edittanpanama.dart';

import 'package:ecashier/searchservive.dart';
import 'package:ecashier/side_drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'editBarang.dart';

void main() => runApp(MyApp());

var gantiNama = true;
var hasil;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ProdukPage(),
    );
  }
}

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['namaBarang'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  var selectedKategori;

  var selectedSupplier;
  String outputValidasi = "Nama Barang Sudah Terdaftar";

  bool sama;
  TextEditingController namaBarang = TextEditingController();
  TextEditingController katBarang = TextEditingController();
  TextEditingController hjBarang = TextEditingController();
  TextEditingController hbBarang = TextEditingController();
  TextEditingController jmlStok = TextEditingController();
  TextEditingController minStok = TextEditingController();
  TextEditingController namaSupplier = TextEditingController();

  TextEditingController leadTime = TextEditingController();
  TextEditingController leadTimeLama = TextEditingController();
  TextEditingController rataPenjualan = TextEditingController();
  TextEditingController rataPenjualanTinggi = TextEditingController();

  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  Future<bool> cek(String value) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
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
      Firestore.instance
          .collection("barang")
          .document(namaBarang.text)
          .setData({
        'namaBarang': namaBarang.text,
        'kategoriBarang': selectedKategori,
        'namaSupplier': selectedSupplier,
        'hjBarang': hjBarang.text,
        'hbBarang': hbBarang.text,
        'jmlStok': jmlStok.text,
        'stokAwal': jmlStok.text,
        'minStok': 0,
        'waktu': formattedDate,
        'leadTime': 0,
        'kategoriPergerakan': 'belum ada',
        'stokPakai': 0,
        'waktuPesan': leadTime.text,
        'waktuPesanLama': leadTimeLama.text,
        'rataPenjualan': rataPenjualan.text,
        'rataPenjualanTinggi': rataPenjualanTinggi.text,
      });
      namaBarang.text = '';
      selectedKategori = null;
      hjBarang.text = '';
      hbBarang.text = '';
      jmlStok.text = '';
      selectedSupplier = null;
      minStok.text = '';
      formattedDate = '';
      leadTime.text = '';
      leadTimeLama.text = '';
      rataPenjualan.text = '';
      rataPenjualanTinggi.text = '';

      await setState(() {
        sama = false;
      });
    }
  }

  var ltDemand;
  @override
  void initState() {
    super.initState();

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Kelola Produk'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SingleChildScrollView(
                  child: Form(
                      key: formKey1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                    onChanged: (val) {
                                      initiateSearch(val);
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          color: Colors.black,
                                          icon: Icon(Icons.arrow_back),
                                          iconSize: 20.0,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 25.0),
                                        hintText: "Cari Produk",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0)))),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            // GridView.count(
                            //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            //   crossAxisCount: 2,
                            //   crossAxisSpacing: 4.0,
                            //   mainAxisSpacing: 4.0,
                            //   primary: false,
                            //   shrinkWrap: true,
                            //   children: tempSearchStore.map((element) {
                            //     return buildResultCard(element);
                            //   }).toList(),
                            // ),

                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Container(
                                  height: 600,
                                  width: 1500,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.grey,
                                  )),
                                  child: StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('barang')
                                        .orderBy('jmlStok', descending: false)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData)
                                        return new Container(
                                          child: Column(
                                            children: <Widget>[
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            ],
                                          ),
                                        );

                                      return new Container(
                                          child: TaskList(
                                        document: snapshot.data.documents,
                                      ));
                                    },
                                  ),
                                )),
                            Container(
                              width: 1250,
                              height: 50,
                              child: RaisedButton(
                                color: Colors.blue,
                                child: Text(
                                  'Tambah',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext konteksAdd) {
                                        return AlertDialog(

                                          content: Stack(
                                            // ignore: deprecated_member_use
                                            overflow: Overflow.visible,
                                            children: <Widget>[
                                              SingleChildScrollView(
                                                child: Form(
                                                  key: formKey2,
                                                  child: Container(
                                                    width: 900,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                vertical: 10,
                                                                horizontal:
                                                                10),
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              color: Colors.lightBlue[200],
                                                              width: 1200,
                                                              height: 40,
                                                              child: Text('Tambah Barang',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20),),
                                                            )
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .words,
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Nama Barang'),
                                                            controller:
                                                                namaBarang,
                                                            validator:
                                                                (namaBarang) {
                                                              if (namaBarang ==
                                                                      null ||
                                                                  namaBarang
                                                                      .isEmpty) {
                                                                return 'Masukan Nama Barang';
                                                              } else {
                                                                cek(namaBarang);
                                                                if (sama ==
                                                                    true) {
                                                                  return outputValidasi;
                                                                } else if (sama ==
                                                                    false) {
                                                                  setState(() {
                                                                    namaBarang =
                                                                        '';
                                                                  });
                                                                  return null;
                                                                }
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        StreamBuilder<
                                                                QuerySnapshot>(
                                                            stream: Firestore
                                                                .instance
                                                                .collection(
                                                                    'kategori')
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Text(
                                                                    "Tidak bisa mendapatkan data");
                                                              } else {
                                                                List<DropdownMenuItem>
                                                                    kategoriItems =
                                                                    [];
                                                                for (int i = 0;
                                                                    i <
                                                                        snapshot
                                                                            .data
                                                                            .documents
                                                                            .length;
                                                                    i++) {
                                                                  DocumentSnapshot
                                                                      snap =
                                                                      snapshot
                                                                          .data
                                                                          .documents[i];
                                                                  kategoriItems.add(
                                                                      DropdownMenuItem(
                                                                    child: Text(
                                                                      snap.data[
                                                                          'namaKategori'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    value:
                                                                        "${snap.data['namaKategori']}",
                                                                  ));
                                                                }
                                                                return Container(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      decoration: InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          labelText:
                                                                              'Kategori Barang'),
                                                                      value:
                                                                          selectedKategori,
                                                                      items:
                                                                          kategoriItems,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return 'Kategori Barang Wajib Diisi';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      onChanged:
                                                                          (kategoriValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedKategori =
                                                                              kategoriValue;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            }),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Harga Beli Barang'),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Harga Beli Wajib Diisi';
                                                              }

                                                              return null;
                                                            },
                                                            inputFormatters: [
                                                              CurrencyTextInputFormatter(
                                                                  locale: 'id',
                                                                  decimalDigits:
                                                                      0,
                                                                  symbol: 'Rp')
                                                            ],
                                                            controller:
                                                                hbBarang,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Harga Jual Barang',
                                                            ),
                                                            inputFormatters: [
                                                              CurrencyTextInputFormatter(
                                                                  locale: 'id',
                                                                  decimalDigits:
                                                                      0,
                                                                  symbol: 'Rp')
                                                            ],
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Harga Jual Wajib Diisi';
                                                              }

                                                              return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                hjBarang,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Jumlah Stok'),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            controller: jmlStok,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Stok Barang Wajib Diisi';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        StreamBuilder<
                                                                QuerySnapshot>(
                                                            stream: Firestore
                                                                .instance
                                                                .collection(
                                                                    'supplier')
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Text(
                                                                    "Tidak bisa mendapatkan data");
                                                              } else {
                                                                List<DropdownMenuItem>
                                                                    supplierItems =
                                                                    [];
                                                                for (int i = 0;
                                                                    i <
                                                                        snapshot
                                                                            .data
                                                                            .documents
                                                                            .length;
                                                                    i++) {
                                                                  DocumentSnapshot
                                                                      snap =
                                                                      snapshot
                                                                          .data
                                                                          .documents[i];
                                                                  supplierItems.add(
                                                                      DropdownMenuItem(
                                                                    child: Text(
                                                                      snap.data[
                                                                          'namaSupplier'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    value:
                                                                        "${snap.data['namaSupplier']}",
                                                                  ));
                                                                }
                                                                return Container(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      decoration: InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          labelText:
                                                                              'Supplier Barang'),
                                                                      value:
                                                                          selectedSupplier,
                                                                      items:
                                                                          supplierItems,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return 'Supplier Barang Wajib Diisi';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      onChanged:
                                                                          (supplierValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedSupplier =
                                                                              supplierValue;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            }),

                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Waktu Pemesanan'),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            controller:
                                                                leadTime,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Stok Barang Wajib Diisi';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Waktu Pemesanan Terlama'),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            controller:
                                                                leadTimeLama,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Stok Barang Wajib Diisi';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Rata- Rata Penjualan'),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            controller:
                                                                rataPenjualan,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Stok Barang Wajib Diisi';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            decoration: InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Rata - Rata Penjualan Tertinggi'),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            controller:
                                                                rataPenjualanTinggi,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Stok Barang Wajib Diisi';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          10),
                                                              // ignore: deprecated_member_use
                                                              child:
                                                                  RaisedButton(
                                                                onPressed:
                                                                    () async {

                                                                  if (formKey2
                                                                      .currentState
                                                                      .validate()) {
                                                                    Navigator.of(
                                                                            konteksAdd)
                                                                        .pop();
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('Data barang berhasil ditambahkan'));
                                                                    ScaffoldMessenger.of(
                                                                            konteksAdd)
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  }
                                                                },
                                                                color:
                                                                    Colors.blue,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        'Simpan',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          10),
                                                              // ignore: deprecated_member_use
                                                              child:
                                                                  RaisedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          konteksAdd)
                                                                      .pop();
                                                                },
                                                                color:
                                                                    Colors.red,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        'Batal',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => TambahBarangPage(),
                                  //     ));
                                },
                              ),
                            )
                          ],
                        ),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});

  final List<DocumentSnapshot> document;

  final _formKey = GlobalKey<FormState>();

  bool jawaban;
  bool hasilnya;

  String outputValidasi = "Nama Barang Sudah Terdaftar";

  Future<bool> deleteBarang(
      DocumentReference index, BuildContext deleteKonteks) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(index);
      await transaction.delete(snapshot.reference);

      await Navigator.of(deleteKonteks).pop();

      jawaban = true;
    });
  }

  @override
  Widget build(BuildContext contextEdit) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (
        BuildContext context,
        int i,
      ) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String hjBarang = document[i].data['hjBarang'].toString();
        String minStok = document[i].data['minStok'].toString();
        String katBarang = document[i].data['kategoriBarang'].toString();
        String hbBarang = document[i].data['hbBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        String namaSupplier = document[i].data['namaSupplier'].toString();

        var intMinStok = int.parse(minStok);
        assert(intMinStok is int);
        var intJmlStok = int.parse(jmlStok);
        assert(intJmlStok is int);

        TextEditingController controllerNama =
            TextEditingController(text: namaBarang);
        TextEditingController controllerHj =
            TextEditingController(text: hjBarang);
        TextEditingController controllerHb =
            TextEditingController(text: hbBarang);
        TextEditingController controllerjmlStok =
            TextEditingController(text: jmlStok);
        TextEditingController controllerminStok =
            TextEditingController(text: minStok);
        final index = document[i].reference;

        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.white60,
            child: Card(
                color: int.parse(minStok) <= int.parse(jmlStok)
                    ? Colors.cyan[50]
                    : Colors.red[200],
                child: ListTile(
                  onTap: () {
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Apakah anda ingin melakukan update pada Nama barang?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
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
                                                    color: Colors.blue,
                                                    child: Text(
                                                      "Ya",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      gantiNama = true;
                                                      Navigator.of(editKonteks)
                                                          .pop();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditBarangPage(
                                                              namaBarang:
                                                                  namaBarang,
                                                              hjBarang:
                                                                  hjBarang,
                                                              minStok: minStok,
                                                              katBarang:
                                                                  katBarang,
                                                              hbBarang:
                                                                  hbBarang,
                                                              jmlStok: jmlStok,
                                                              namaSupplier:
                                                                  namaSupplier,
                                                              index: document[i]
                                                                  .reference,
                                                            ),
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
                                                    color: Colors.blue,
                                                    child: Text(
                                                      "Tidak",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(editKonteks)
                                                          .pop();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TanpaNamaPage(
                                                              namaBarang:
                                                                  namaBarang,
                                                              hjBarang:
                                                                  hjBarang,
                                                              minStok: minStok,
                                                              katBarang:
                                                                  katBarang,
                                                              hbBarang:
                                                                  hbBarang,
                                                              jmlStok: jmlStok,
                                                              namaSupplier:
                                                                  namaSupplier,
                                                              index: document[i]
                                                                  .reference,
                                                            ),
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 50,
                                            width: 180,
                                            child: RaisedButton(
                                              color: Colors.red,
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.of(editKonteks).pop();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  leading: Icon(
                    intMinStok <= intJmlStok
                        ? Icons.format_list_bulleted
                        : Icons.report,
                    color: Colors.black,
                  ),
                  title: Text(
                    namaBarang,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    hjBarang,
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    'Stok : ' + jmlStok,
                    style: TextStyle(fontSize: 20),
                  ),
                )),
          ),
        );
      },
    );
  }
}
