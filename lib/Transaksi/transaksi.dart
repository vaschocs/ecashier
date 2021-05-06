

import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Transaksi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: TransaksiPage(),
        ));
  }
}

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  var selectedKategori;

  String outputValidasi = "Nama Barang Sudah Terdaftar";

  bool sama;

  TextEditingController katBarang = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Tambah Produk'),
        backgroundColor: Colors.green,
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
                                  ),
                                  value: selectedKategori,
                                  items: kategoriItems,

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
                  ],
                ),
              ),
            ),
          ),
          // StreamBuilder(
          //   stream: Firestore.instance.collection('riwayatRestock').snapshots(),
          //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (!snapshot.hasData)
          //       return new Container(
          //           child: Center(
          //             child: CircularProgressIndicator(),
          //           ));
          //     return new TaskList(
          //       document: snapshot.data.documents,
          //     );
          //   },
          // ),
        ],
      )
    );
  }
}
class TaskList extends StatelessWidget {
  TaskList({this.document});

  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String waktu = document[i].data['waktu'].toString();

        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.white60,
            child: Card(
                shape: Border.all(color: Colors.green),
                child: ListTile(
                  onTap: () async {},
                  leading: Icon(Icons.history),
                  title: Text(
                    'Nama Barang : ' + namaBarang,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'Waktu : ' + waktu,
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          ),
        );
      },
    );
  }
}

