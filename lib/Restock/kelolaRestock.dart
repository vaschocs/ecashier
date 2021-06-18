
import 'package:ecashier/Restock/restock.dart';
import 'package:ecashier/Restock/riwayat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecashier/side_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Kelola Restock',

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: KelolaRestockPage(),
        )

    );
  }
}

class KelolaRestockPage extends StatelessWidget {
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
                Tab(text: 'Restock'),
                Tab(text: 'Riwayat Stok'),

              ],
            ),
            title: Text('Kelola Restock'),
            backgroundColor: Colors.blue,
          ),
          body: TabBarView(
            children: [
              RestockPage(),
              RiwayatPage(),
            ],
          ),
        ),
      ),
    );
  }
}





