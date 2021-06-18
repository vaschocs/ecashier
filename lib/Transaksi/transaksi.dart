
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bill.dart';

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
          body: TransaksiPage(),
        ));
  }
}


class TransaksiPage extends StatefulWidget {
  TransaksiPage(
      {this.namaBarang,
        this.katBarang,
        this.hjBarang,
        this.hbBarang,
        this.jmlStok,
        this.minStok,
        this.namaSupplier,

        this.index});

  final String namaBarang;
  final String katBarang;
  final String hjBarang;
  final String hbBarang;
  final String jmlStok;
  final String minStok;
  final index;

  final String namaSupplier;
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {

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
        title: Text('Transaksi'),
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

            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: 10),
            child: Container(
              height: 650,
              width: 1500,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('barang').where('kategoriBarang',isEqualTo: selectedKategori).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot>
                    snapshot) {
                  print(selectedKategori);
                  if (!snapshot.hasData)
                    return new Container(
                        child: Center(
                          child:
                          CircularProgressIndicator(),
                        ));
                  return new TaskList(
                    document:
                    snapshot.data.documents,
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
        String minStok = document[i].data['minStok'].toString();
        String katBarang = document[i].data['kategoriBarang'].toString();
        String hbBarang = document[i].data['hbBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();



        return new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            color: Colors.white60,
            child: Card(
                shape: Border.all(color: Colors.blue),
                child: ListTile(
                  onTap: () {
                    intStok = int.parse(jmlStok);
                    assert(intStok is int);

                    if(intStok == 0){
                      final snackBar =
                      SnackBar(content: Text('Stok Barang Habis'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return true;
                    }else {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context)=> new BillPage(
                            namaBarang: namaBarang,
                            katBarang: katBarang,
                            hjBarang : hjBarang,
                            hbBarang : hbBarang,
                            jmlStok: jmlStok,
                            minStok: minStok,

                            index : document[i].reference,
                          )
                      ));


                    }
                    return null;

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