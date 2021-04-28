import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());
BuildContext konteks;
TextEditingController editSatuan;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Satuan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SatuanPage(),
      ),
    );
  }
}

class SatuanPage extends StatefulWidget {
  SatuanPage({this.namaSatuan});
  String namaSatuan;

  @override
  _SatuanPageState createState() => _SatuanPageState();
}

class _SatuanPageState extends State<SatuanPage> {

  TextEditingController namaSatuan = TextEditingController();
  TextEditingController editSatuan;
  String idSatuan;

  final _formKey = GlobalKey<FormState>();

  void add(List<DocumentSnapshot> documents) async {
    if (documents.length >= 1) {
      final snackBar = SnackBar(content: Text('Nama Satuan Sudah Terdaftar'));

      ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
    } else {
      Firestore.instance
          .collection("satuan")
          .document(namaSatuan.text)
          .setData({'namaSatuan': namaSatuan.text});

      final snackBar =
      SnackBar(content: Text('Nama Satuan Berhasil Ditambahkan'));
      ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
    }
    namaSatuan.text = '';
  }

  Future<bool> doesNameAlreadyExist() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('satuan')
        .where('namaSatuan', isEqualTo: namaSatuan.text)
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
        stream: Firestore.instance.collection('satuan').snapshots(),
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
                                  labelText: 'Nama Satuan',
                                ),
                                controller: namaSatuan,
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
  String namaSatuan;


  void updateSatuan(List<DocumentSnapshot> documents, DocumentReference index, String editSatuan) async {
    if (documents.length >= 1) {
      final snackBar = SnackBar(
          content: Text(
              'Nama Satuan Sudah Terdaftar'));
      ScaffoldMessenger.of(
          konteks)
          .showSnackBar(
          snackBar);
    } else {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(snapshot.reference, {
          "namaSatuan": editSatuan,
        });
      });
    }
  }

  Future<bool> doesNameAlreadyExist(index, editSatuan) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('satuan')
        .where('editSatuan', isEqualTo: namaSatuan)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    updateSatuan(documents,index,editSatuan);
  }

  void deleteSatuan(
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
        String namaSatuan = document[i].data['namaSatuan'].toString();
        String idSatuan = document[i].data['idSatuan'].toString();
        TextEditingController editSatuan =
        TextEditingController(text: namaSatuan);
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
                            namaSatuan,
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
                                                      'Nama Satuan'),
                                                  controller: editSatuan,
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
                                                        doesNameAlreadyExist(index,editSatuan.text);
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
                                                "Apakah benar anda ingin menghapus satuan" +
                                                    ' ' +
                                                    namaSatuan +
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
                                                        deleteSatuan(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                        final snackBar = SnackBar(
                                                            content: Text(
                                                                'Satuan'
                                                                    ' '+ namaSatuan +' Berhasil Dihapus'));
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
