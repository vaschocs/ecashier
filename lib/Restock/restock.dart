import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
      home: RestockPage(),
    );
  }
}

class RestockPage extends StatefulWidget {
  @override
  _RestockPageState createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('barang').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});

  final List<DocumentSnapshot> document;

  TextEditingController tambahStok = TextEditingController();

  Future<bool> update(DocumentReference index, BuildContext konteksUpdate2,
      int stokNow, String namaBarang) async {
    int addStok = int.tryParse(tambahStok.text);

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(index);
      await transaction
          .update(snapshot.reference, {"jmlStok": addStok + stokNow});
    });

    Navigator.of(konteksUpdate2).pop();

    return null;
  }

  Future<bool> add(
      DocumentReference index, int stokNow, String namaBarang) async {
    int addStok = int.tryParse(tambahStok.text);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    Firestore.instance.collection("riwayatRestock").document().setData({
      'namaBarang': namaBarang,
      'tambahStok': addStok,
      'waktu': formattedDate,
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String satuanBarang = document[i].data['satuan'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        final index = document[i].reference;

        int stokNow = int.parse(jmlStok);
        TextEditingController showBarang = TextEditingController(text: namaBarang);
        TextEditingController showStok = TextEditingController(text: jmlStok);

        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.white60,
            child: Card(
                shape: Border.all(color: Colors.green),
                child: ListTile(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext konteksUpdate) {
                            return AlertDialog(
                              title: Text('Informasi Barang'),
                              content: Stack(
                                // ignore: deprecated_member_use
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Container(
                                      height: 400,
                                      width: 400,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: TextFormField(
                                              enabled: false,
                                              textCapitalization:
                                              TextCapitalization.words,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:'Nama Barang',
                                              ),
                                              controller:showBarang,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: TextFormField(
                                              enabled: false,
                                              textCapitalization:
                                              TextCapitalization.words,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:'Jumlah Stok',
                                              ),
                                              controller:showStok,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1),
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Masukan jumlah stok';
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          konteksUpdate2) {
                                                        new TaskList();
                                                        return AlertDialog(
                                                          content: Stack(
                                                            // ignore: deprecated_member_use
                                                            overflow: Overflow
                                                                .visible,
                                                            children: <Widget>[
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "Apakah benar anda ingin menambah Stok Barang " +
                                                                          namaBarang +
                                                                          ' sebanyak ' +
                                                                          tambahStok
                                                                              .text +
                                                                          ' ' +
                                                                          satuanBarang +
                                                                          " ?",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              30,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                180,
                                                                            child:
                                                                                RaisedButton(
                                                                              color: Colors.green,
                                                                              child: Text("Tambah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                                                                              onPressed: () {
                                                                                add(index, stokNow, namaBarang);
                                                                                update(index, konteksUpdate, stokNow, namaBarang);
                                                                                Navigator.of(konteksUpdate).pop();
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                180,
                                                                            child:
                                                                                RaisedButton(
                                                                              child: Text("Batal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                                                                              onPressed: () {
                                                                                Navigator.of(konteksUpdate2).pop();
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
                                                return null;
                                              },
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    'Tambah Stok ' + namaBarang,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: tambahStok,
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
                                                      "Tambah",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      if (_formKey.currentState.validate());
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
                                                    child: Text("Batal"),
                                                    onPressed: () {
                                                      Navigator.of(
                                                              konteksUpdate)
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
                    leading: Icon(Icons.sticky_note_2_outlined),
                    title: Text(
                      namaBarang,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      'Jumlah Stok : ' + jmlStok,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(Icons.add))),
          ),
        );
      },
    );
  }
}
