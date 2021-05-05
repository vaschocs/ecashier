
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
      home: TransaksiPage(),
    );
  }
}

class TransaksiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('ECASHIER'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.green)),
                onPressed: () {},
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_bag,
                        color: Colors.black,
                      ),
                      Text(
                        'Penjualan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '                                          ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Rp 0',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_sharp,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(195, 170), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.green)),
                        color: Colors.white60,
                        borderOnForeground: true, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
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
                              Text("Kelola Produk"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(195, 170), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.green)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
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
                              Text("Tambah Stok"), // text
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
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(195, 170
                    ), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.green)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.file_copy),
                              Text(" "), // icon
                              Text("Laporan"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(195, 170), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.green)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.compare_arrows_sharp),
                              Text(" "), // icon
                              Text("Pergerakan Barang"), // text
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
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox.fromSize(
                    size: Size(195, 170), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.green)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.history),
                              Text(" "), // icon
                              Text("History"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(195, 170), // button width and height
                    child: ClipRect(
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            side: BorderSide(width: 2, color: Colors.green)),
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: () =>{Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransaksiPage(),
                              ))},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.attach_money),
                              Text(" "), // icon
                              Text("Transaksi"), // text
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
