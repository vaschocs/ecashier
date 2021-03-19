import 'package:ecashier/Barang/kategori.dart';
import 'package:ecashier/Barang/produk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecashier/side_drawer.dart';

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
      home: KelolaBarangPage(),
    );
  }
}

class KelolaBarangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Produk',),
              Tab(text: 'Kategori'),
            ],
          ),
          title: Text('Kelola Produk'),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: [
            ProdukPage(),
            KategoriPage()

          ],
        ),
      ),
    ),
    );
  }
}





