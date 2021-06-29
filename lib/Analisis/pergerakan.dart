import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Analisis Pergerakan Barang',
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: AnalisPage(),));
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
        title: Text('Analisis Produk',),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(
              height: 730,
              width: 1500,
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.grey,
              )),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('barang')
                    .where('kategoriBarang', isEqualTo: selectedKategori)
                    .orderBy('kategoriPergerakan', descending: true)
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
      itemBuilder: (BuildContext context, int i,) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String hjBarang = document[i].data['hjBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        String stokAwal = document[i].data['stokAwal'].toString();
        String stokPakai = document[i].data['stokPakai'].toString();
        String waktu = document[i].data['waktu'].toString();
        String analisis = document[i].data['kategoriPergerakan'].toString();
        String waktuPesan = document[i].data['waktuPesan'].toString();
        String waktuPesanLama = document[i].data['waktuPesanLama'].toString();
        String rataJual = document[i].data['rataPenjualan'].toString();
        String rataJualTinggi = document[i].data['rataPenjualanTinggi'].toString();


        var rata2,torp,minimalStok,safetyStock,ltDemand,wsp,tor;
        String kategori;

        ltDemand = int.parse(waktuPesan) * int.parse(rataJual);
        safetyStock = (((int.parse(waktuPesanLama) * int.parse(rataJualTinggi))) - (int.parse(waktuPesan) * int.parse(rataJual)));
        rata2 = (int.parse(stokAwal) + int.parse(jmlStok)) / 2;
        torp = int.parse(stokPakai) / rata2;
        minimalStok = ltDemand + safetyStock;

        DateTime startDate = DateTime.parse(waktu);
        DateTime endDate = DateTime.now();
        final selisihHari = endDate.difference(startDate).inDays;
        wsp = selisihHari / torp;
        tor = 365 / wsp;



        Future<bool> update() async {
          Firestore.instance.runTransaction((Transaction transaction) async {
            DocumentSnapshot snapshot = await transaction.get(document[i].reference);
            await transaction.update(snapshot.reference, {
              'kategoriPergerakan': kategori,
              'minStok': minimalStok});
          });
          return null;
        }

        Future hasilKategori() {
          if (tor > 3) {
            kategori = 'Sangat Laku';
          } else if (tor <= 1) {
            kategori = 'Kurang Laku';
          } else if (tor <= 3) {
            kategori = 'Laku';
          }
          return null;
        }

        GlobalKey<FormState> _formKey = GlobalKey<FormState>();

        return new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            color: Colors.white60,
            child: Card(
                color: (analisis == 'Kurang Laku')
                    ? Colors.red[200]
                    : (analisis == 'Laku')
                        ? Colors.lightGreen[200]
                        : (analisis == "Sangat Laku")
                            ? Colors.cyan[50]
                            : Colors.amber[200],
                child: ListTile(
                    onTap: () {
                      hasilKategori();
                      showDialog(
                          context: context,
                          builder: (BuildContext analisisbarang) {
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
                                                      'Jumlah Stok',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      jmlStok,
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
                                                      'Lama Penyimpanan',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(selisihHari.toString() + ' hari',
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
                                                      'Total Penjualan',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      stokPakai,
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
                                                      kategori.toString(),
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
                                                      'Minimal Stok',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      minimalStok.toString(),
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
                                                  width: 450,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    color: Colors.grey,
                                                  )),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                              // ignore: deprecated_member_use
                                              child: RaisedButton(
                                                onPressed: () async {

                                                  update();
                                                  Navigator.of(analisisbarang)
                                                      .pop();
                                                },
                                                color: Colors.blue,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 400,
                                                      child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ),
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
                    leading: Icon(
                        analisis == 'Kurang Laku'
                            ? Icons.report
                            : Icons.format_list_bulleted,
                        color: Colors.black),
                    title: Text(
                      namaBarang,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    subtitle: Text(
                      hjBarang,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    trailing: Text(
                      analisis.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ))),
          ),
        );
      },
    );
  }
}
