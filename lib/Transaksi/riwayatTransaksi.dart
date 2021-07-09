import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../side_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riwayat Transaksi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: RiwayatTransaksiPage(),
    );
  }
}

class RiwayatTransaksiPage extends StatefulWidget {
  @override
  _RiwayatTransaksiPageState createState() => _RiwayatTransaksiPageState();
}

List<Map> riwayatTransaksi = new List<Map>();

Future getDataTransaksi() async {
  // ignore: await_only_futures
  await Firestore.instance
      .collection('detailTransaksi')
      .snapshots()
      .listen((documents) {
    riwayatTransaksi.clear();
    if (documents.documents.length != 0) {
      documents.documents.forEach((d) {
        Map document = new Map();
        document['Item'] = d['Item'];
        document['kembalian'] = d['kembalian'];
        document['tanggalTransaksi'] = d['tanggalTransaksi'];
        document['totalHarga'] = d['totalHarga'];
        document['uangDiterima'] = d['uangDiterima'];
        riwayatTransaksi.add(document);
      });
    }
  });
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController searchBar = new TextEditingController();
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }
  List<dynamic> namaBarang = List<String>();
  List<String> getHasilNama = List<String>();
  List<dynamic> getNama = List<String>();

  getItem() {
    for (int i = 0; i < riwayatTransaksi.length; i++) {
     getNama = riwayatTransaksi[i]['Item'].toList();
        for (int a = 0; a < getNama.length; a++) {
          setState(() {
            getHasilNama.add(getNama[a]['namaBarang']);
            return null;
          });
        }
    }
  }







  void initState() {
    super.initState();
    getDataTransaksi();
    getItem();
    print(getHasilNama);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text('Riwayat Tranksasi'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 250,
                    // child: Card(
                    //   child: ListTile(
                    //     trailing: Icon(Icons.arrow_drop_down),
                    //     title: Text('Pilih Tanggal Riwayat'),
                    //     onTap: () => _selectDate(context),
                    //   ),
                    // ),
                  ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   height: 60,
                  //   width: 130,
                  //   child: Card(
                  //     child: ListTile(
                  //       title: Text(selectedDate.toString().substring(0, 11)),
                  //       onTap: () => _selectDate(context),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                ),
                width: 1250,
                height: 630,
                child: ListView.builder(
                  itemCount: riwayatTransaksi.length,
                  itemBuilder: (context, i) {
                    final b = riwayatTransaksi[i];
                    return new Container(
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
                                            child: Form(
                                              child: Container(
                                                width: 600,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              'Detail Restock',
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              b['tanggalTransaksi'],
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 30,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                  'Nama Barang',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                            ),
                                                            // Container(
                                                            //   child: Text(namaBarang),
                                                            // ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                  'Nama Supplier',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                            ),
                                                            // Container(
                                                            //   child: Text(namaSupplier),
                                                            // ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                  'Harga Beli',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                            ),
                                                            // Container(
                                                            //   child: Text(hargaBeli),
                                                            // ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                  'Stok Awal',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                            ),
                                                            // Container(
                                                            //   child: Text(stokAwal + " pcs"),
                                                            // ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                  'Tambah Stok',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                            ),
                                                            // Container(
                                                            //   child: Text(addStok+ " pcs"),
                                                            // ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                  'Total Stok',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                            ),
                                                            // Container(
                                                            //   child: Text((int.parse(stokAwal)+int.parse(addStok)).toString()+ " pcs"),
                                                            // ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.black87,
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            height: 50,
                                                            width: 580,
                                                            // ignore: deprecated_member_use
                                                            child: RaisedButton(
                                                              color:
                                                                  Colors.blue,
                                                              child: Text(
                                                                "OK",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white),
                                                              ),
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
                            leading: Icon(Icons.history),
                            trailing: Text(
                              'Total Transaksi : Rp ' +
                                  b['Item'].length.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            title: Text(
                              getHasilNama.toString(),
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Tanggal : ' + b['tanggalTransaksi'],
                              style: TextStyle(fontSize: 18),
                            ),
                          )),
                    );
                  },
                )),
          ],
        ));
  }
}

// class TaskList extends StatelessWidget {
//   TaskList({this.document});
//   final List<DocumentSnapshot> document;
//
//   @override
//   Widget build(BuildContext context) {
//     return new ListView.builder(
//       itemCount: document.length,
//       itemBuilder: (BuildContext context, int i) {
//
//         List<dynamic> getNama = document[i].data['Item'].toList();
//         List <String> getHasilNama = List<String>();
//          getNamaBarang() {
//           for (int a = 0; a < getNama.length; a++) {
//           getHasilNama.add(getNama[a]['namaBarang']);
//           }
//
//           return null;
//         }
//
//         String totalHarga = document[i].data['totalHarga'].toString();
//
//         String tanggalTransaksi =
//             document[i].data['tanggalTransaksi'].toString().substring(0, 11);
//         // String stokAwal = document[i].data['stokAwal'].toString();
//         // String namaSupplier = document[i].data['namaSupplier'].toString();
//         // String hargaBeli = document[i].data['hargaBeli'].toString();
//         // String addStok = document[i].data['addStok'].toString();
//
//         return new Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Container(
//             color: Colors.white60,
//             child: Card(
//                 shape: Border.all(color: Colors.blue),
//                 child: ListTile(
//                   onTap: () async {
// getNamaBarang();
// print(getHasilNama);
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext konteksUpdate) {
//                           return AlertDialog(
//                             content: Stack(
//                               // ignore: deprecated_member_use
//                               overflow: Overflow.visible,
//                               children: <Widget>[
//                                 SingleChildScrollView(
//                                   child: Form(
//                                     child: Container(
//                                       width: 600,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: <Widget>[
//                                           Column(
//                                             children: <Widget>[
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: <Widget>[
//                                                   Text(
//                                                     'Detail Restock',
//                                                     style: TextStyle(
//                                                         fontSize: 30,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   Text(
//                                                     tanggalTransaksi,
//                                                     style:
//                                                         TextStyle(fontSize: 20),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 height: 30,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     child: Text('Nama Barang',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 20)),
//                                                   ),
//                                                   // Container(
//                                                   //   child: Text(namaBarang),
//                                                   // ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 height: 20,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     child: Text('Nama Supplier',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 20)),
//                                                   ),
//                                                   // Container(
//                                                   //   child: Text(namaSupplier),
//                                                   // ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 height: 20,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     child: Text('Harga Beli',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 20)),
//                                                   ),
//                                                   // Container(
//                                                   //   child: Text(hargaBeli),
//                                                   // ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 height: 20,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     child: Text('Stok Awal',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 20)),
//                                                   ),
//                                                   // Container(
//                                                   //   child: Text(stokAwal + " pcs"),
//                                                   // ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 height: 20,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     child: Text('Tambah Stok',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 20)),
//                                                   ),
//                                                   // Container(
//                                                   //   child: Text(addStok+ " pcs"),
//                                                   // ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 height: 20,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     child: Text('Total Stok',
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 20)),
//                                                   ),
//                                                   // Container(
//                                                   //   child: Text((int.parse(stokAwal)+int.parse(addStok)).toString()+ " pcs"),
//                                                   // ),
//                                                 ],
//                                               ),
//                                               Container(
//                                                 height: 20,
//                                               ),
//                                             ],
//                                           ),
//                                           Divider(
//                                             color: Colors.black87,
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: <Widget>[
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: SizedBox(
//                                                   height: 50,
//                                                   width: 580,
//                                                   // ignore: deprecated_member_use
//                                                   child: RaisedButton(
//                                                     color: Colors.blue,
//                                                     child: Text(
//                                                       "OK",
//                                                       style: TextStyle(
//                                                           fontSize: 20,
//                                                           color: Colors.white),
//                                                     ),
//                                                     onPressed: () {
//                                                       Navigator.of(
//                                                               konteksUpdate)
//                                                           .pop();
//                                                     },
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         });
//                   },
//                   leading: Icon(Icons.history),
//                   trailing: Text(
//                     'Total Transaksi : Rp ' +
//                         document[i].data['Item'].length.toString(),
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   title: Text(
//                     'Nama Barang : ' + getHasilNama.toString(),
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   subtitle: Text(
//                     'Tanggal : ' + tanggalTransaksi,
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 )),
//           ),
//         );
//       },
//     );
//   }
// }
