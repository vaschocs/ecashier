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
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot kategori = snapshot.data.documents[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.menu),
                  title: Text(
                    kategori['Nama Kategori'],
                    style: TextStyle(fontSize: 20),
                  ),
                  dense: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.green,
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Stack(
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
                    }
                  ),
                ),
              );
            },
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
