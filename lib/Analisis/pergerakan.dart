
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());
var intStok;
var itemName;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    itemName = null;
    return MaterialApp(
        title: 'Transaksi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: AnalisPage(),
        ));
  }
}

class AnalisPage extends StatefulWidget {
  @override
  _AnalisPageState createState() => _AnalisPageState();
}

class _AnalisPageState extends State<AnalisPage> {
  var selectedKategori;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(
          'Analisis Produk',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('kategori')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Tidak bisa mendapatkan data");
                          } else {
                            List<DropdownMenuItem> kategoriItems = [];
                            for (int i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              DocumentSnapshot snap =
                                  snapshot.data.documents[i];
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
                                  child: Column(
                                    children: <Widget>[
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Pilih Kategori',
                                        ),
                                        value: selectedKategori,
                                        items: kategoriItems,
                                        onChanged: (kategoriValue) {
                                          setState(() {
                                            selectedKategori = kategoriValue;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(
              height: 650,
              width: 1500,
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.grey,
              )),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('barang')
                    .where('kategoriBarang', isEqualTo: selectedKategori)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return new Container(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  return new TaskList(
                    document: snapshot.data.documents,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (
        BuildContext context,
        int i,
      ) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String hjBarang = document[i].data['hjBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        String stokAwal = document[i].data['stokAwal'].toString();
        String stokPakai = document[i].data['stokPakai'].toString();
        String waktu = document[i].data['waktu'].toString();

        TextEditingController waktuPesan;

        var intJumlah = int.parse(jmlStok);
        assert(intJumlah is int);

        var intStokAwal = int.parse(stokAwal);
        assert(intStokAwal is int);

        var intStokPakai = int.parse(stokPakai);
        assert(intStokPakai is int);

        var rata2;
        rata2 = (intStokAwal + intJumlah) / 2;

        var TORp;
        TORp = intStokPakai / rata2;
        var sTORp = TORp.toString().substring(0, 4);

        DateTime startDate = DateTime.parse(waktu);
        DateTime endDate = DateTime.now();
        final selisihHari = endDate.difference(startDate).inDays;

        var Wsp;
        Wsp = selisihHari / TORp;

        var TOR;
        TOR = 365 / Wsp;
        var sTOR = TOR.toString().substring(0, 4);

        String kategori;

        Future hasilKategori() {
          if (TOR > 3) {
            kategori = 'Sangat Laku';
          } else if (TOR <= 3 || TOR >= 1) {
            kategori = 'Laku';
          } else {
            kategori = 'Tidak Laku';
          }
        }

        GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        GlobalKey<FormState> formKey = GlobalKey<FormState>();
        return new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            color: Colors.white60,
            child: Card(
                shape: Border.all(color: Colors.blue),
                child: ListTile(
                    onTap: () {

                      hasilKategori();
                      showDialog(
                          context: context,
                          builder: (BuildContext AnalisisBarang) {
                            return AlertDialog(
                              content: Stack(
                                // ignore: deprecated_member_use
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  SingleChildScrollView(
                                    child: Form(
                                      key: _formKey,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.analytics,
                                                    size: 50,
                                                  ),
                                                ),
                                                Text(
                                                  'Analisis Data Barang',
                                                  style: TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  namaBarang,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30),
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Rata Persediaan ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      rata2.toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'TORp',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      sTORp,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Wsp',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      Wsp.toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'TOR',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      sTOR,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Kategori',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      kategori,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: 800,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    color: Colors.grey,
                                                  )),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        10),
                                                            child: Text(
                                                              'Keterangan',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 5,
                                                      ),
                                                      Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 180,
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          10),
                                                                  child: Text(
                                                                    'Rata Persediaan',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 20,
                                                                child: Text(
                                                                  ':',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  'Rata - rata persediaan barang',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                  width: 180,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            10),
                                                                    child: Text(
                                                                      'TORp',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                width: 20,
                                                                child: Text(
                                                                  ':',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  'Perputaran persediaan selama periode pengamatan',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                  width: 180,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            10),
                                                                    child: Text(
                                                                      'Wsp',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                width: 20,
                                                                child: Text(
                                                                  ':',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  'Lamanya waktu penyimpanan selama periode pengamatan',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                  width: 180,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            10),
                                                                    child: Text(
                                                                      'TOR',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                width: 20,
                                                                child: Text(
                                                                  ':',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  'Perputaran persediaan selama 1 tahun',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  child: RaisedButton(
                                                    onPressed: () async {
                                                      Navigator.of(
                                                              AnalisisBarang)
                                                          .pop();

                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext minimalstok) {
                                                            return AlertDialog(
                                                              title: Text("Pengaturan Minimum Stok"),
                                                              content: Stack(
                                                                // ignore: deprecated_member_use
                                                                overflow: Overflow.visible,
                                                                children: <Widget>[
                                                                  Form(
                                                                    key: formKey,
                                                                    child: Container(
                                                                      height: 150,
                                                                      width: 400,
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding:
                                                                            EdgeInsets.symmetric(
                                                                                vertical: 1),
                                                                            child: TextFormField(
                                                                              keyboardType: TextInputType.number,
                                                                              textCapitalization:
                                                                              TextCapitalization
                                                                                  .words,
                                                                              decoration:
                                                                              InputDecoration(
                                                                                border:
                                                                                OutlineInputBorder(),
                                                                                labelText:
                                                                                'Waktu Pemesanan',
                                                                              ),

                                                                              controller: waktuPesan,
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                padding:
                                                                                const EdgeInsets
                                                                                    .all(8.0),
                                                                                child: SizedBox(
                                                                                  height: 50,
                                                                                  width: 180,
                                                                                  child: RaisedButton(
                                                                                    color: Colors.blue,
                                                                                    child: Text(
                                                                                      "Edit",
                                                                                      style: TextStyle(
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .bold,
                                                                                          fontSize: 20,
                                                                                          color: Colors
                                                                                              .white),
                                                                                    ),
                                                                                    onPressed:
                                                                                        () async {
                                                                                      if (_formKey
                                                                                          .currentState
                                                                                          .validate()) ;
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding:
                                                                                const EdgeInsets
                                                                                    .all(8.0),
                                                                                child: SizedBox(
                                                                                  height: 50,
                                                                                  width: 180,
                                                                                  child: RaisedButton(
                                                                                    child: Text("Batal",
                                                                                        style: TextStyle(
                                                                                            fontWeight:
                                                                                            FontWeight
                                                                                                .bold,
                                                                                            fontSize:
                                                                                            20,
                                                                                            color: Colors
                                                                                                .black)),
                                                                                    onPressed: () {
                                                                                      Navigator.of(
                                                                                          minimalstok)
                                                                                          .pop();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    color: Colors.blue,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Minimal Stok',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
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
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  child: RaisedButton(
                                                    onPressed: () async {
                                                      Navigator.of(
                                                          AnalisisBarang)
                                                          .pop();

                                                    },
                                                    color: Colors.red,
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Keluar',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
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
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    leading: Icon(Icons.format_list_bulleted),
                    title: Text(
                      namaBarang,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      hjBarang,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(Icons.analytics))),
          ),
        );
      },
    );
  }
}
