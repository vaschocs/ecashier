import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());
BuildContext konteks;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelola Kategori',
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
  TextEditingController namaKategori = TextEditingController();
  TextEditingController editKategori;
  String idKategori;
  String outputValidasi = "Nama Kategori Sudah Terdaftar";

  bool sama;

  final _formKey = GlobalKey<FormState>();

  Future<bool> cek(String value, BuildContext konteksAdd) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('kategori')
        .where('namaKategori', isEqualTo: value)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length >= 1) {
      await setState(() {
        sama = true;
      });
    } else {
      Firestore.instance
          .collection("kategori")
          .document()
          .setData({'namaKategori': value});

      await Navigator.of(konteksAdd).pop();

      final snackBar =
          SnackBar(content: Text('Nama Kategori Berhasil Ditambahkan'));
      ScaffoldMessenger.of(konteks).showSnackBar(snackBar);

      namaKategori.text = '';

      await setState(() {
        sama = false;
      });
    }
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
              builder: (BuildContext konteksAdd) {
                return AlertDialog(
                  title: Text('Tambah Kategori'),
                  content: Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          color: Colors.white,
                          height: 150,
                          width: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nama Kategori',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukan Nama Kategori Baru';
                                    } else {
                                      cek(value, konteksAdd);
                                      if (sama) {
                                        return outputValidasi;
                                      } else if (!sama) {
                                        setState(() {
                                          value = '';
                                        });
                                        return null;
                                      }
                                    }
                                    return null;
                                  },
                                  controller: namaKategori,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 180,
                                      child: RaisedButton(
                                        color: Colors.green,
                                        child: Text(
                                          "Simpan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState.validate())
                                            ;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 180,
                                      child: RaisedButton(
                                        child: Text("Batal",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black)),
                                        onPressed: () {
                                          Navigator.of(konteksAdd).pop();
                                          setState(() {
                                            namaKategori.text = '';
                                          });
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
  String outputValidasi = "Nama Kategori Sudah Terdaftar";
  String error = "Nama Kategori berkaitan dengan Data Barang";
  bool hasil;
  bool adaBarang;
  bool adaFile;
  bool fileUsed;

  Future<bool> update(
      DocumentReference index, String value, BuildContext konteksUpdate) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('kategori')
        .where('namaKategori', isEqualTo: value)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = await result.documents;
    if (documents.length >= 1) {
      hasil = true;
    } else {
      hasil = false;
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(snapshot.reference, {"namaKategori": value});
        Navigator.of(konteksUpdate).pop();
        final snackBar =
            SnackBar(content: Text('Nama Kategori berhasil diubah'));
        ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
      });
    }

    namaKategori = '';

    return null;
  }



  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (
        BuildContext konteksUpdate,
        int i,
      ) {
        String namaKategori = document[i].data['namaKategori'].toString();
        TextEditingController editKategori =
            TextEditingController(text: namaKategori);
        final index = document[i].reference;

        Future<bool> updateBarang(DocumentReference index) async {
          final QuerySnapshot result = await Firestore.instance
              .collection('barang')
              .where('kategoriBarang', isEqualTo:editKategori.text)
              .limit(1)
              .getDocuments();
          final List<DocumentSnapshot> documents = await result.documents;
          if (documents.length >= 1) {
            adaBarang = true;
          } else {
            adaBarang = false;
          }
          return null;
        }
        // ignore: missing_return
        Future<bool> deleteKategori(
            DocumentReference index, BuildContext deleteKonteks) async {
          final QuerySnapshot result = await Firestore.instance
              .collection('barang')
              .where('kategoriBarang', isEqualTo: namaKategori)
              .limit(1)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;

          if (documents.length >= 1) {
            adaFile = true;
          } else {
            Firestore.instance.runTransaction((transaction) async {
              // final snackBar = SnackBar(
              DocumentSnapshot snapshot = await transaction.get(index);
              await transaction.delete(snapshot.reference);

              Navigator.of(deleteKonteks).pop();

              final snackBar =
                  SnackBar(content: Text('Kategori ' ' berhasil dihapus'));
              ScaffoldMessenger.of(konteks).showSnackBar(snackBar);

              adaFile = false;
            });
          }
        }

        String value;

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
                          onPressed: () async {
                            updateBarang(index);
                            print('adabarang' + adaBarang.toString());
                            if (adaBarang == true) {
                              final snackBar = SnackBar(
                                  content: Text('Kategori ' +
                                      namaKategori +
                                      ' tidak dapat diubah karna berkaitan Data Barang'));
                              ScaffoldMessenger.of(konteks)
                                  .showSnackBar(snackBar);
                            } else if (adaBarang == false) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext konteksUpdate) {
                                    return AlertDialog(
                                      title: Text("Edit Kategori"),
                                      content: Stack(
                                        // ignore: deprecated_member_use
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Form(
                                            key: _formKey,
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
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            'Nama Kategori',
                                                      ),
                                                      validator: (value) {
                                                        update(index, value,
                                                            konteksUpdate);
                                                        print('JAWABAN' +
                                                            adaBarang
                                                                .toString());
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Masukan Nama Kategori Baru';
                                                        } else if (hasil ==
                                                            true) {
                                                          return outputValidasi;
                                                        }
                                                        return null;
                                                      },
                                                      controller: editKategori,
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
                                                            color: Colors.green,
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
                            }
                          }),
                      new IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.green,
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext deleteKonteks) {
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 180,
                                                      child: RaisedButton(
                                                        color: Colors.green,
                                                        child: Text(
                                                          "Hapus",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          deleteKategori(index,
                                                              deleteKonteks);
                                                          if (adaFile == true) {
                                                            Navigator.of(
                                                                    deleteKonteks)
                                                                .pop();
                                                            final snackBar = SnackBar(
                                                                content: Text(
                                                                    'Kategori ' +
                                                                        namaKategori +
                                                                        ' tidak dapat dihapus karna berkaitan dengan barang yang ada'));
                                                            ScaffoldMessenger
                                                                    .of(konteks)
                                                                .showSnackBar(
                                                                    snackBar);
                                                          } else {}
                                                          return null;
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
                                                        child: Text("Batal",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 30,
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
