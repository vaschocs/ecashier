import 'package:ecashier/Analisis/pergerakan.dart';
import 'package:ecashier/Barang/produk.dart';
import 'package:ecashier/Restock/kelolaRestock.dart';
import 'package:ecashier/Transaksi/riwayatTransaksi.dart';
import 'package:ecashier/Transaksi/transaksi.dart';
import 'package:ecashier/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ecashier/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Barang/kategori.dart';
import 'Barang/supplier.dart';


class SideDrawer extends StatefulWidget {
  SideDrawerState createState() => new SideDrawerState();
}


class SideDrawerState extends State<SideDrawer>{
  final FirebaseAuth firebaseauth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();


  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();


  }



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child:Column(
                children: <Widget>[
                  Container(
                    height: 50,
                  ),
                  Text(
                    'Toko Susu Laris Jaya',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Text(info.toString(), textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 23))

                ],
              )
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Beranda'),
            onTap: () => {Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => HomePage(),
            ))},
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Kelola Produk'),
            onTap: ()  {
              getData();
              Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ProdukPage(),
            ));},
          ),

          ListTile(
            leading: Icon(Icons.category),
            title: Text('Kelola Kategori'),
            onTap: () => {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KategoriPage(),
                ))},
          ),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Kelola Supplier'),
            onTap: () => {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplierPage(),
                ))},
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart_sharp),
            title: Text('Restock'),
            onTap: () =>{Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KelolaRestockPage(),
                ))},
          ),

          // ListTile(
          //   leading: Icon(Icons.file_copy),
          //   title: Text('Laporan'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          ListTile(
            leading: Icon(Icons.compare_arrows_sharp),
            title: Text('Pergerakan Barang'),
            onTap: () => {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalisPage(),
                ))},
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Transaksi'),
            onTap: ()  {
    getDataTransaksi();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RiwayatTransaksiPage(),
                ));},
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Transaksi'),
            onTap: () =>{Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransaksiPage()
                ))},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              _logOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> MyLogin())
              );}
          ),

        ],
      ),
    );
  }
}