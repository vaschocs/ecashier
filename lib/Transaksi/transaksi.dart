import 'package:ecashier/data.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
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




class BillItem {
  BillItem({this.nama, this.harga, this.jumlahStok});

  final String nama;
  final String harga;
  final String jumlahStok;
}

List<BillItem> items = [];
Map<String, int> countItem = new Map<String, int>();


// List<Map> items = new List<Map>();

class TransaksiPage extends StatefulWidget {
  TransaksiPage({this.namaBarang});

  final String namaBarang;
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

List dataTable;

class _TransaksiPageState extends State<TransaksiPage> {
  String namaBarang;
  List cards = new List.generate(transaksiItem.length, (int index) => new StateCard(index)).toList();
  List<Map> _search = [];
  onSearch(String text) async {

    _search.clear();
    if (text.isEmpty) {
      for (int i = 0; i < transaksiItem.length; i++) {
        setState(() {
          Map document = new Map();
          document['hbBarang'] = transaksiItem[i]['hbBarang'];
          document['docDate'] = transaksiItem[i]['docDate'];
          document['hjBarang'] = transaksiItem[i]['hjBarang'];
          document['jmlStok'] = transaksiItem[i]['jmlStok'];
          document['jmlStok'] = transaksiItem[i]['jmlStok'];
          document['kategoriBarang'] = transaksiItem[i]['kategoriBarang'];
          document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
          document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
          document['minStok'] =transaksiItem[i] ['minStok'];
          document['namaBarang'] = transaksiItem[i]['namaBarang'];
          document['namaSupplier'] =transaksiItem[i] ['namaSupplier'];
          document['rataPenjualan'] =transaksiItem[i] ['rataPenjualan'];
          document['rataPenjualanTinggi'] = transaksiItem[i]['rataPenjualanTinggi'];
          document['stokAwal'] =transaksiItem[i] ['stokAwal'];
          document['stokPakai'] =transaksiItem[i] ['stokPakai'];
          document['tanggalPergerakan'] = transaksiItem[i]['tanggalPergerakan'];
          document['waktu'] = transaksiItem[i]['waktu'];
          document['waktuPesan'] = transaksiItem[i]['waktuPesan'];
          document['waktuPesanLama'] = transaksiItem[i]['waktuPesanLama'];
          _search.add(document);
        });


      }
      return;
    }

    for (int i = 0; i < transaksiItem.length; i++) {
      if (transaksiItem[i]['namaBarang'].toString().contains(text) ||transaksiItem[i]['kategoriBarang'].toString().contains(text)  ) {
        setState(() {
          Map document = new Map();
          document['hbBarang'] = transaksiItem[i]['hbBarang'];
          document['hjBarang'] = transaksiItem[i]['hjBarang'];
          document['docDate'] = transaksiItem[i]['docDate'];
          document['jmlStok'] = transaksiItem[i]['jmlStok'];
          document['jmlStok'] = transaksiItem[i]['jmlStok'];
          document['kategoriBarang'] = transaksiItem[i]['kategoriBarang'];
          document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
          document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
          document['minStok'] =transaksiItem[i] ['minStok'];
          document['namaBarang'] = transaksiItem[i]['namaBarang'];
          document['namaSupplier'] =transaksiItem[i] ['namaSupplier'];
          document['rataPenjualan'] =transaksiItem[i] ['rataPenjualan'];
          document['rataPenjualanTinggi'] = transaksiItem[i]['rataPenjualanTinggi'];
          document['stokAwal'] =transaksiItem[i] ['stokAwal'];
          document['stokPakai'] =transaksiItem[i] ['stokPakai'];
          document['tanggalPergerakan'] = transaksiItem[i]['tanggalPergerakan'];
          document['waktu'] = transaksiItem[i]['waktu'];
          document['waktuPesan'] = transaksiItem[i]['waktuPesan'];
          document['waktuPesan'] = transaksiItem[i]['waktuPesan'];
          document['waktuPesanLama'] = transaksiItem[i]['waktuPesanLama'];
          _search.add(document);

        });
      }
    }
  }

  TextEditingController searchBar = new TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  var harga;
  var jmlHarga;

  @override
  Widget build(BuildContext iniKonteks) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                  controller: searchBar,
                    onChanged:onSearch,
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
                    width: 1,
                  ),
                ),
                width: 1265,
                height: 680,
                child: _search.length != 0 || searchBar.text.isNotEmpty
                    ? ListView.builder(
                  itemCount: _search.length,
                  itemBuilder: (context, i) {
                    final b = _search[i];
                    return new Container(
                      child: Card(
                          color: int.parse(transaksiItem[i]['jmlStok'].toString()) == 0
                              ? Colors.black45
                              : int.parse(transaksiItem[i]['minStok'].toString()) <=
                              int.parse(transaksiItem[i]['jmlStok'].toString())
                              ? Colors.lightBlue[100]
                              : Colors.redAccent[100],
                          child: ListTile(
                            onTap: () {
                              if (int.parse(transaksiItem[i]['jmlStok'].toString()) == 0) {
                              } else {
                                setState(() {
                                  transaksiItem[i]['jmlStok'] =
                                      int.parse(transaksiItem[i]['jmlStok'].toString()) - 1;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BillPage(
                                          namaBarang: transaksiItem[i]['namaBarang'],
                                          minStok: transaksiItem[i]['minStok'].toString(),
                                          jmlStok: transaksiItem[i]['jmlStok'].toString(),
                                          hjBarang: transaksiItem[i]['hjBarang'].toString(),
                                          indexBarang: transaksiItem[i].toString()
                                      ),
                                    ));
                              }
                            },
                            leading: Icon(
                              int.parse(transaksiItem[i]['minStok'].toString()) <=
                                  int.parse(transaksiItem[i]['jmlStok'].toString())
                                  ? Icons.format_list_bulleted
                                  : Icons.report,
                              color: Colors.black,
                            ),
                            title: Text(
                              transaksiItem[i]['namaBarang'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              transaksiItem[i]['hjBarang'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            trailing: Text(
                              'Jumlah Stok : ' + transaksiItem[i]['jmlStok'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )),
                    );
                  },
                )
                    :
                ListView.builder(
                  itemCount: transaksiItem.length,
                  itemBuilder: (context,i){
                    return new Container(
                      child: Card(
                          color: int.parse(transaksiItem[i]['jmlStok'].toString()) == 0
                              ? Colors.black45
                              : int.parse(transaksiItem[i]['minStok'].toString()) <=
                              int.parse(transaksiItem[i]['jmlStok'].toString())
                              ? Colors.lightBlue[100]
                              : Colors.redAccent[100],
                          child: ListTile(
                            onTap: () {
                              if (int.parse(transaksiItem[i]['jmlStok'].toString()) == 0) {
                              } else {
                                setState(() {
                                  transaksiItem[i]['jmlStok'] =
                                      int.parse(transaksiItem[i]['jmlStok'].toString()) - 1;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BillPage(
                                          namaBarang: transaksiItem[i]['namaBarang'],
                                          minStok: transaksiItem[i]['minStok'].toString(),
                                          jmlStok: transaksiItem[i]['jmlStok'].toString(),
                                          hjBarang: transaksiItem[i]['hjBarang'].toString(),
                                          indexBarang: transaksiItem[i].toString()
                                      ),
                                    ));
                              }
                            },
                            leading: Icon(
                              int.parse(transaksiItem[i]['minStok'].toString()) <=
                                  int.parse(transaksiItem[i]['jmlStok'].toString())
                                  ? Icons.format_list_bulleted
                                  : Icons.report,
                              color: Colors.black,
                            ),
                            title: Text(
                              transaksiItem[i]['namaBarang'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              transaksiItem[i]['hjBarang'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            trailing: Text(
                              'Jumlah Stok : ' + transaksiItem[i]['jmlStok'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )),
                    );
                  },

                ),
              ),
            ],
          ),
        ));
  }
}
