import 'package:ecashier/Restock/kelolaRestock.dart';
import 'package:ecashier/Transaksi/transaksi.dart';
import 'package:ecashier/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecashier/Barang/kelolaBarang.dart';
import 'package:ecashier/home.dart';
import 'package:google_sign_in/google_sign_in.dart';


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
            onTap: () =>{Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => KelolaRestockPage(),
                ))},
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
            leading: Icon(Icons.attach_money),
            title: Text('Transaksi'),
            onTap: () =>{Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TransaksiPage(),
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