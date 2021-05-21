import 'package:ecashier/Barang/editBarang.dart';
import 'package:ecashier/Transaksi/transaksi.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

var itemName;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    itemName = null;
    return MaterialApp(
        title: 'Bill',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BillPage(),
        ));
  }
}

class LOL {

}

class BillPage extends StatefulWidget {
  BillPage(
      {this.namaBarang,
        this.katBarang,
        this.hjBarang,
        this.hbBarang,
        this.jmlStok,
        this.minStok,
        this.namaSupplier,
        this.satuan,
        this.index});

  final String namaBarang;
  final String katBarang;
  final String hjBarang;
  final String hbBarang;
  final String jmlStok;
  final String minStok;
  final index;
  final String satuan;
  final String namaSupplier;
  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  var itemName;
  var hargaBarang;

List<_BillPageState> items = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    itemName = widget.namaBarang;
    hargaBarang = widget.hjBarang;
  }

  Iterable<DataRow> mapItemDataRows(List<_BillPageState> items) {
    Iterable<DataRow> dataRows = items.map((item){
      return DataRow(
        cells: [
          DataCell(Text(item.itemName),),
          DataCell(Text(item.itemName),),
          DataCell(Text(item.itemName),),
        ]);
    });
    return dataRows;
  }

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

             child: DataTable(
               columns: const <DataColumn>[
                 DataColumn(
                   label: Text(
                     'Name',
                     style: TextStyle(fontStyle: FontStyle.italic),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Age',
                     style: TextStyle(fontStyle: FontStyle.italic),
                   ),
                 ),
                 DataColumn(
                   label: Text(
                     'Role',
                     style: TextStyle(fontStyle: FontStyle.italic),
                   ),
                 ),
               ],
             rows:
               mapItemDataRows(items).toList()
             ,
             ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransaksiPage(),
          ));
    },
    label: Text('Tambah'),
    icon: Icon(Icons.add),
    backgroundColor: Colors.green,
    ),);
  }


}

