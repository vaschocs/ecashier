import 'package:flutter/material.dart';
import 'package:ecashier/Barang/kelola_barang.dart';
import 'package:ecashier/home.dart';


class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Toko Susu Laris Jaya',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Beranda'),
            onTap: () => {Navigator.pushReplacement(
            context,
            MaterialPageRoute(
            builder: (context) => HomePage(),
            ))},
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Kelola Produk'),
            onTap: () => {Navigator.pushReplacement(
            context,
            MaterialPageRoute(
            builder: (context) => KelolaBarangPage(),
            ))},
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart_sharp),
            title: Text('Restock'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text('Laporan'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.compare_arrows_sharp),
            title: Text('Pergerakan Barang'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Retur'),
            onTap: () => {Navigator.of(context).pop()},
          ),

        ],
      ),
    );
  }
}