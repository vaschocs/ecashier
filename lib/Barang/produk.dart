import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecashier/Barang/add_barang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecashier/DatabaseManager/db_add_barang.dart';

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
      home: ProdukPage(),
    );
  }
}

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List dataBarangList = [];

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await DatabaseManager().getBarangList();

    if (resultant == null) {
      print('Tidak bisa mendapatkan data');
    } else {
      setState(() {
        dataBarangList = resultant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance.collection('barang').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot barang = snapshot.data.documents[index];
                return Card(
                  child:  ListTile(
                    leading: SizedBox.fromSize(
                      size: Size(60, 60), // button width and height
                      child: ClipRect(
                        child: Material(
                          color: Colors.grey, // button color
                        ),
                      ),
                    ),
                    title: Text(
                      barang['Nama Barang'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    dense: true,
                    subtitle: Row(
                      children: <Widget>[
                        Text('Rp '),
                        Text(barang['Harga Jual']),
                      ],
                    ),
                    trailing: Column(
                      children: <Widget>[Text('Stok'), Text(barang['Jumlah Stok'])],
                    ),
                  ),
                );

              },
            );
          },
        ),
      ],),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahBarangPage(),
              ));
        },
        label: Text('Tambah'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
