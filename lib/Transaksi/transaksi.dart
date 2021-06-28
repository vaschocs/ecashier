import 'package:ecashier/data.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bill.dart';

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

Future getData() async {
  await Firestore.instance.collection('barang').snapshots().listen((documents) {
    TransaksiItem.clear();
    if (documents.documents.length != 0) {
      documents.documents.forEach((d) {
        Map document = new Map();
        document['namaBarang'] = d['namaBarang'];
        document['hbBarang'] = d['hbBarang'];
        document['minStok'] = d['minStok'];
        document['jmlStok'] = d['jmlStok'];
        TransaksiItem.add(document);
      });
    }
  });
}

class BillItem {
  BillItem({this.nama, this.harga, this.jumlahStok});

  final String nama;
  final String harga;
  final String jumlahStok;
}

// class Transaksi {
//   Transaksi({this.namaBarang, this.hbBarang, this.jmlStok, this.minStok});
//
//   String namaBarang;
//   String hbBarang;
//
//   String jmlStok;
//   String minStok;
//
//   Map<String, dynamic> toMap() {
//     return {
//       'namaBarang': namaBarang,
//       'hbBarang': hbBarang,
//       'jmlStok': jmlStok,
//       'minStok': minStok
//     };
//   }
// }

List<Map> TransaksiItem = new List<Map>();
List<Map> items = new List<Map>();

class TransaksiPage extends StatefulWidget {
  TransaksiPage({this.namaBarang});

  final String namaBarang;
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

List dataTable;

class _TransaksiPageState extends State<TransaksiPage> {
  String namaBarang;
  List cards = new List.generate(TransaksiItem.length, (int index) => new StateCard(index)).toList();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    getData();
    Map isiCard = new Map();
    isiCard['namaBarang'] = 'belum ada';
    isiCard['hbBarang'] = 'belum ada';
    isiCard['minStok'] = 'belum ada';
    isiCard['jmlStok'] = 'belum ada';
    items.add(isiCard);

    dataTable = new List.generate(items.length, (int index) => new StateTable(index)).toList();
  }

  var harga;
  var jmlHarga;

  // Iterable<DataRow> mapItemDataRows(List<Map> items) {
  //   Iterable<DataRow> dataRows = items.map((item) {
  //     var newPrice = item[i]['namaBarang'];
  //     var fixPrice = newPrice.replaceAll(".", "");
  //     intPrice = int.parse(fixPrice);
  //     assert(intPrice is int);
  //     harga = countItem[item.namaBarang] * intPrice;
  //     jmlHarga = jmlHarga + harga;
  //
  //     intStok = int.parse(item.jumlahStok);
  //     assert(intStok is int);
  //
  //     return DataRow(cells: [
  //       DataCell(
  //         Text(
  //           item.namaBarang,
  //         ),
  //       ),
  //       DataCell(
  //         Text(intPrice.toString()),
  //       ),
  //       DataCell(Text(countItem[item.namaBarang].toString())),
  //       DataCell(Text((harga).toString())),
  //       DataCell(TextButton.icon(
  //         onPressed: () async {
  //           await Firestore.instance
  //               .runTransaction((Transaction transaction) async {
  //             DocumentSnapshot snapshot = await transaction.get(newIndex);
  //             await transaction.update(snapshot.reference, {
  //               'jmlStok':  intStok + countItem[item.namaBarang],
  //             });
  //           });
  //           print(intStokLocal+countItem[item.namaBarang]);
  //
  //           setState(() {
  //             var newPrice = item.hargaBarang;
  //             var fixPrice = newPrice.replaceAll(".", "");
  //             intPrice = int.parse(fixPrice);
  //             assert(intPrice is int);
  //             harga = countItem[item.namaBarang] * intPrice;
  //             jmlHarga = (jmlHarga - harga);
  //             items.remove(item);
  //             countItem.remove(item.namaBarang);
  //           });
  //         },
  //         icon: Icon(
  //           Icons.delete,
  //           color: Colors.red,
  //         ),
  //         label: Text(
  //           'Hapus',
  //           style: TextStyle(color: Colors.red),
  //         ),
  //       )),
  //     ]);
  //   });
  //   return dataRows;
  // }

  @override
  Widget build(BuildContext iniKonteks) {
    return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text('Transaksi'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    onChanged: (val) {
                      // initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.arrow_back),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: "Cari Produk",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0)))),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 3,
                  ),
                ),
                width: 1265,
                height: 350,
                child: ListView(
                  children: cards,
                ),
              ),
              Container(
                height: 5,
              ),
              Container(
                width: 1265,
                height: 330,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 3,
                  ),
                ),
               child: ListView(
                  children: dataTable,
                )
              ),
            ],
          ),
        ));
  }
}
