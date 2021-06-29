import 'package:ecashier/data.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

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
  List cards = new List.generate(
      TransaksiItem.length, (int index) => new StateCard(index)).toList();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  var harga;
  var jmlHarga;

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
                height: 680,
                child: ListView(
                  children: cards,
                ),
              ),
            ],
          ),
        ));
  }
}
