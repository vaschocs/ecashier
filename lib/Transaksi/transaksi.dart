import 'package:filter_list/filter_list.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {git
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
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
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
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                            child: Container(
                                              height: 650,
                                              width: 1500,
                                              color: Colors.white,
                                              // child:  StreamBuilder(
                                              //   stream: Firestore.instance.collection('barang').snapshots(),
                                              //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                              //     final QuerySnapshot result = await Firestore.instance
                                              //         .collection('barang')
                                              //         .where('namaBarang', isEqualTo: value)
                                              //         .limit(1)
                                              //         .getDocuments();
                                              //     final List<DocumentSnapshot> documents = result.documents;
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
                                            ),

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
          ],
        ));
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
        String minStok = document[i].data['minStok'].toString();
        String katBarang = document[i].data['kategoriBarang'].toString();
        String hbBarang = document[i].data['hbBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        String satuan = document[i].data['satuan'].toString();

        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.white60,
            child: Card(
                shape: Border.all(color: Colors.green),
                child: ListTile(
                  onTap: () {
                    // Navigator.of(context).push(new MaterialPageRoute(
                    //     builder: (BuildContext context) => new EditBarangPage(
                    //           namaBarang: namaBarang,
                    //           katBarang: katBarang,
                    //           hjBarang: hjBarang,
                    //           hbBarang: hbBarang,
                    //           jmlStok: jmlStok,
                    //           minStok: minStok,
                    //           satuan: satuan,
                    //           index: document[i].reference,
                    //         )));
                  },
                  leading: Icon(Icons.format_list_bulleted),
                  title: Text(
                    namaBarang,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'Rp. ' + hjBarang,
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
