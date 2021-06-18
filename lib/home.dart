import 'package:ecashier/Analisis/pergerakan.dart';
import 'package:ecashier/Transaksi/transaksi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:ecashier/Barang/kelolaBarang.dart';
import 'package:ecashier/Restock/kelolaRestock.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('ECASHIER'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
Container(
height: 50,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(400, 300), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.blue)),
                        color: Colors.white60,
                        borderOnForeground: true, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KelolaBarangPage(),
                                ));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.shopping_basket),
                              Text(" "), // icon
                              Text("Kelola Produk",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(400, 300), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(),
                            side: BorderSide(width: 2, color: Colors.blue)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KelolaRestockPage(),
                                ));
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add_shopping_cart_sharp),
                              Text(" "), // icon
                              Text("Tambah Stok",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(400, 300), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.blue)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.file_copy),
                              Text(" "), // icon
                              Text("Laporan",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(400, 300), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.blue)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnalisPage(),
                                ));
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.compare_arrows_sharp),
                              Text(" "), // icon
                              Text("Pergerakan Barang",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(400, 300), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(),
                            side: BorderSide(width: 2, color: Colors.blue)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.history),
                              Text(" "), // icon
                              Text("History",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(400, 300), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.blue)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color
                          onTap: () =>{Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransaksiPage(),
                              ))},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.attach_money),
                              Text(" "), // icon
                              Text("Transaksi",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
