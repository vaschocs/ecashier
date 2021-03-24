import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecashier/DatabaseManager/db_add_kat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add kategori',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: KategoriPage(),
    );
  }
}

class KategoriPage extends StatefulWidget {
  KategoriPage({this.namaKategori});
  final String namaKategori;

  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  List dataKategoriList = [];
  TextEditingController namaKategori = TextEditingController();
  String idKategori;

  final _formKey = GlobalKey<FormState>();

  void add() async {
    Firestore.instance.collection("kategori").document(idKategori).setData(
        {'Nama Kategori': namaKategori.text, 'id Kategori': idKategori});

    namaKategori.text = '';
    idKategori = new DateTime.now().microsecondsSinceEpoch.toString();
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await DatabaseManager().getKategoriList();

    if (resultant == null) {
      print('Tidak bisa mendapatkan data');
    } else {
      setState(() {
        dataKategoriList = resultant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('kategori').snapshots(),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nama Kategori'),
                                controller: namaKategori,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text("Batal"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    color: Colors.green,
                                    child: Text(
                                      "Simpan",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      add();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        label: Text('Tambah'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document, this.index});

  final List<DocumentSnapshot> document;
  final index;

  String newKategori;
  @override
  Widget build(BuildContext context) {





    final _formKey = GlobalKey<FormState>();

    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String namaKategori = document[i].data['Nama Kategori'].toString();
        TextEditingController editKategori =
            TextEditingController(text: namaKategori);

        // void updateKategori() {
        //   Firestore.instance.runTransaction((Transaction transaction) async {
        //     DocumentSnapshot snapshot = await transaction.get(i);
        //     await transaction.update(snapshot.reference,{
        //       "editKategori" : newKategori
        //     });
        //   });
        // }
        return new Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.menu, color: Colors.green),
                    ),
                    Text(
                      namaKategori,
                      style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                    ),
                    new IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.green,
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    // ignore: deprecated_member_use
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Nama Kategori'),
                                                controller: editKategori,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    child: Text("Batal"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: Colors.green,
                                                    child: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      updateKategori();
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
