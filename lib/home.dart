import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:ecashier/Barang/kelolaBarang.dart';

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
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RaisedButton(
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
                    size: Size(195, 130), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.white60,
                        borderOnForeground: true, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: () {
                            Navigator.pushReplacement(
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
                    size: Size(195, 130), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add_shopping_cart_sharp),
                              Text(" "), // icon
                              Text("Restock"), // text
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
                    size: Size(195, 130), // button width and height
                    child: ClipRect(
                      child: Material(
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
                    size: Size(195, 130), // button width and height
                    child: ClipRect(
                      child: Material(
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
                    size: Size(195, 130), // button width and height
                    child: ClipRect(
                      child: Material(
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
                    size: Size(195, 130), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.white60, // button color
                        child: InkWell(
                          splashColor: Colors.green, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.cancel_sharp),
                              Text(" "), // icon
                              Text("Retur"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20),
                child : RaisedButton(onPressed: () {},
                  color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Mulai Transaksi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),),

                )
          ],

        ),
      ),
    );
  }
}
