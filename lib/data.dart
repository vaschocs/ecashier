import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Transaksi/transaksi.dart';

class StateCard extends StatefulWidget {
  int i;
  StateCard(this.i);
  @override
  CustomCard createState() => new CustomCard(i);
}

class CustomCard extends State<StateCard> {
  int i;
  CustomCard(this.i);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Card(
          color:
              // int.parse(TransaksiItem[i]['minStok'].toString()) <= int.parse(TransaksiItem[i]['jmlStok'].toString()) ? Colors.white60 : Colors.redAccent,
              int.parse(TransaksiItem[i]['jmlStok'].toString()) == 0
                  ? Colors.grey.shade300
                  : int.parse(TransaksiItem[i]['minStok'].toString()) <=
                          int.parse(TransaksiItem[i]['jmlStok'].toString())
                      ? Colors.redAccent[100]
                      : Colors.lightBlue[100],
          child: ListTile(
            onTap: () {
              print('tes'+items.length.toString());
              if (int.parse(TransaksiItem[i]['jmlStok'].toString()) == 0) {
              } else {
                setState(() {
                  TransaksiItem[i]['jmlStok'] = int.parse(TransaksiItem[i]['jmlStok'].toString()) - 1;
                      Map isiCard = new Map();
                      isiCard['namaBarang'] = TransaksiItem[i]['namaBarang'];
                  items.add(isiCard);
                  dataTable = new List.generate(items.length, (int index) => new StateTable(index)).toList();
                });

              }
            },
            leading: Icon(
              int.parse(TransaksiItem[i]['minStok'].toString()) <=
                      int.parse(TransaksiItem[i]['jmlStok'].toString())
                  ? Icons.format_list_bulleted
                  : Icons.report,
              color: Colors.black
                  ,
            ),
            title: Text(
              TransaksiItem[i]['namaBarang'],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:  Colors.black
                      ),
            ),
            subtitle: Text(
              TransaksiItem[i]['hbBarang'].toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:  Colors.black
                  ),
            ),
            trailing: Text(
              'Jumlah Stok : ' + TransaksiItem[i]['jmlStok'].toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:  Colors.black
                  ),
            ),
          )),
    );
  }
}

class StateTable extends StatefulWidget {
  int i;
  StateTable(this.i);
  @override
  CustomTable createState() => new CustomTable(i);
}

class CustomTable extends State<StateTable> {
  int i;
  CustomTable(this.i);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Card(

          child: ListTile(
            onTap: () {},
            leading: Icon(
              int.parse(TransaksiItem[i]['minStok'].toString()) <=
                  int.parse(TransaksiItem[i]['jmlStok'].toString())
                  ? Icons.format_list_bulleted
                  : Icons.report,
              color: int.parse(TransaksiItem[i]['minStok'].toString()) <=
                  int.parse(TransaksiItem[i]['jmlStok'].toString())
                  ? Colors.black
                  : Colors.white,
            ),
            title: Text(
             items[i]['hbBarang'],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      Colors.black
              )
            ),
            // subtitle: Text(
            //   items[i]['hbBarang'].toString(),
            //   style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: int.parse(TransaksiItem[i]['minStok'].toString()) <=
            //           int.parse(TransaksiItem[i]['jmlStok'].toString())
            //           ? Colors.black
            //           : Colors.white),
            // ),
            // trailing: Text(
            //   'Jumlah Stok : ' + items[i]['jmlStok'].toString(),
            //   style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: int.parse(TransaksiItem[i]['minStok'].toString()) <=
            //           int.parse(TransaksiItem[i]['jmlStok'].toString())
            //           ? Colors.black
            //           : Colors.white),
            // ),
          )),
    );
  }
}