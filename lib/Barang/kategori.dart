import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());
BuildContext konteks;
TextEditingController editKategori;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add kategori',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: KategoriPage(),
      ),
    );
  }
}

class KategoriPage extends StatefulWidget {
  KategoriPage({this.namaKategori});
  String namaKategori;

  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  // List dataKategoriList = [];
  TextEditingController namaKategori = TextEditingController();
  TextEditingController editKategori;
  String idKategori;

  final _formKey = GlobalKey<FormState>();

  void add(List<DocumentSnapshot> documents) async {
    if (documents.length >= 1) {
      final snackBar = SnackBar(content: Text('Nama Kategori Sudah Terdaftar'));

      ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
    } else {
      Firestore.instance
          .collection("kategori")
          .document(namaKategori.text)
          .setData({'namaKategori': namaKategori.text});

      final snackBar =
          SnackBar(content: Text('Nama Kategori Berhasil Ditambahkan'));
      ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
    }
    namaKategori.text = '';
  }

  Future<bool> doesNameAlreadyExist() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('kategori')
        .where('namaKategori', isEqualTo: namaKategori.text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    add(documents);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      konteks = context;
    });
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
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama Kategori',
                                ),
                                controller: namaKategori,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    color: Colors.green,
                                    child: Text(
                                      "Simpan",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      await doesNameAlreadyExist();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text("Batal"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
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
  TaskList({this.document});

  final List<DocumentSnapshot> document;
  String namaKategori;


  void updateKategori(List<DocumentSnapshot> documents, DocumentReference index, String editKategori) async {
    if (documents.length >= 1) {
      final snackBar = SnackBar(
          content: Text(
              'Nama Kategori Sudah Terdaftar'));
      ScaffoldMessenger.of(
          konteks)
          .showSnackBar(
          snackBar);
    } else {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(snapshot.reference, {
          "namaKategori": editKategori,
        });
      });
    }
  }

  Future<bool> doesNameAlreadyExist(index, editKategori) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('kategori')
        .where('editKategori', isEqualTo: namaKategori)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    updateKategori(documents,index,editKategori);
  }

  void deleteKategori(
    DocumentReference index,
  ) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(index);
      await transaction.delete(snapshot.reference);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (
        BuildContext context,
        int i,
      ) {
        String namaKategori = document[i].data['namaKategori'].toString();
        String idKategori = document[i].data['idKategori'].toString();
        TextEditingController editKategori =
            TextEditingController(text: namaKategori);
        final index = document[i].reference;

        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              color: Colors.white60,
              child: Card(
                shape: Border.all(color: Colors.green),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.menu, color: Colors.green),
                          ),
                          Text(
                            namaKategori,
                            style: new TextStyle(
                                fontSize: 20.0, letterSpacing: 1.0),
                          ),
                        ]),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                        Widget>[
                      new IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.green,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  new TaskList();
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
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          'Nama Kategori'),
                                                  controller: editKategori,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RaisedButton(
                                                      color: Colors.green,
                                                      child: Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        doesNameAlreadyExist(index,editKategori.text);
                                                        Navigator.of(context)
                                                            .pop();
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
                          }),
                      new IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.green,
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  new TaskList();
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
                                                "Apakah benar anda ingin menghapus kategori" +
                                                    ' ' +
                                                    namaKategori +
                                                    "?",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RaisedButton(
                                                      color: Colors.green,
                                                      child: Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        deleteKategori(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                        final snackBar = SnackBar(
                                                            content: Text(
                                                                 'Kategori '+ namaKategori +' Berhasil Dihapus'));
                                                        ScaffoldMessenger.of(
                                                                konteks)
                                                            .showSnackBar(
                                                                snackBar);
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: RaisedButton(
                                                      child: Text("Batal"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          })
                    ]),
                  ],
                ),
              )),
        );
      },
    );
  }
}
