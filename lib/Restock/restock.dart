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

// ignore: must_be_immutable
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
          .update(snapshot.reference, {
            "jmlStok": addStok + stokNow,

      });
    });

    Navigator.of(konteksUpdate2).pop();

    return null;
  }


  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        String namaSupplier = document[i].data['namaSupplier'].toString();
        String hargaBeli = document[i].data['hbBarang'].toString();
        final index = document[i].reference;

        int stokNow = int.parse(jmlStok);

        Future<bool> add(
            DocumentReference index, int stokNow, String namaBarang) async {
          int addStok = int.tryParse(tambahStok.text);
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd 00:00:00.000').format(now);
          String formattedTime = DateFormat('hh:mm:ss').format(now);
          Firestore.instance.collection("riwayatRestock").document().setData({
            'namaBarang': namaBarang,
            'addStok': addStok,
            'tanggal': formattedDate,
            'waktu':formattedTime,
            'namaSupplier' : namaSupplier,
            'stokAwal' : jmlStok,
            'hargaBeli' : hargaBeli
          });

          return null;
        }


        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.white60,
            child: Card(
                shape: Border.all(color: Colors.blue),
                child: ListTile(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext konteksUpdate) {
                            return AlertDialog(

                              content: Stack(
                                // ignore: deprecated_member_use
                                overflow: Overflow.visible,
                                children: <Widget>[
                                 SingleChildScrollView(
                                   child:  Form(
                                     key: _formKey,
                                     child: Container(
                                       height: 420,
                                       width: 600,
                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         children: <Widget>[

                                           Column(
                                             children:<Widget> [
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: <Widget>[
                                                   Container(
                                                   ),
                                                   Text('Informasi Barang',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                                                 ],
                                               ),

                                               Container(
                                                 height: 30,
                                               ),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                   Container(
                                                     child: Text('Nama Barang',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                                   ),
                                                   Container(
                                                     child: Text(namaBarang),
                                                   ),
                                                 ],
                                               ),
                                               Container(
                                                 height: 20,
                                               ),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                   Container(
                                                     child: Text('Jumlah Stok',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                                   ),
                                                   Container(
                                                     child: Text(jmlStok),
                                                   ),
                                                 ],
                                               ),
                                              Container(
                                                height: 20,
                                              ),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                   Container(
                                                     child: Text('Nama Supplier',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                                   ),
                                                   Container(
                                                     child: Text(namaSupplier),
                                                   ),
                                                 ],
                                               ),
                                               Container(
                                                 height: 20,
                                               ),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                   Container(
                                                     child: Text('Harga Beli',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                                   ),
                                                   Container(
                                                     child: Text(hargaBeli),
                                                   ),
                                                 ],
                                               ),
                                               Container(
                                                 height: 20,
                                               ),
                                             ],
                                           ),



                                           Divider(
                                             color: Colors.black87,height: 10,
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
                                                   Navigator.of(konteksUpdate).pop();
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
                                                                           ' ' + 'pcs',
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
                                                                           .end,
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
                                                                             // ignore: deprecated_member_use
                                                                             RaisedButton(
                                                                               color: Colors.blue,
                                                                               child: Text("Tambah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                                                                               onPressed: () {
                                                                                add(index, stokNow, namaBarang);
                                                                                 update(index, konteksUpdate, stokNow, namaBarang);
                                                                                 Navigator.of(konteksUpdate2).pop();
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
                                                                             // ignore: deprecated_member_use
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
                                             MainAxisAlignment.end,
                                             children: <Widget>[
                                               Padding(
                                                 padding:
                                                 const EdgeInsets.all(8.0),
                                                 child: SizedBox(
                                                   height: 50,
                                                   width: 180,
                                                   // ignore: deprecated_member_use
                                                   child: RaisedButton(
                                                     color: Colors.blue,
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
                                                   // ignore: deprecated_member_use
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
                                 )
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
