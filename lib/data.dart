import 'package:ecashier/Transaksi/bill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Barang/editBarang.dart';
import 'Barang/edittanpanama.dart';
import 'main.dart';





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
          color: int.parse(transaksiItem[i]['jmlStok'].toString()) == 0
              ? Colors.black45
              : int.parse(transaksiItem[i]['minStok'].toString()) <=
              int.parse(transaksiItem[i]['jmlStok'].toString())
              ? Colors.lightBlue[100]
              : Colors.redAccent[100],
          child: ListTile(
            onTap: () {
              if (int.parse(transaksiItem[i]['jmlStok'].toString()) == 0) {
              } else {
                setState(() {
                  transaksiItem[i]['jmlStok'] =
                      int.parse(transaksiItem[i]['jmlStok'].toString()) - 1;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillPage(
                          namaBarang: transaksiItem[i]['namaBarang'],
                          minStok: transaksiItem[i]['minStok'].toString(),
                          jmlStok: transaksiItem[i]['jmlStok'].toString(),
                          hjBarang: transaksiItem[i]['hjBarang'].toString(),
                          indexBarang: transaksiItem[i].toString()
                      ),
                    ));
              }
            },
            leading: Icon(
              int.parse(transaksiItem[i]['minStok'].toString()) <=
                  int.parse(transaksiItem[i]['jmlStok'].toString())
                  ? Icons.format_list_bulleted
                  : Icons.report,
              color: Colors.black,
            ),
            title: Text(
              transaksiItem[i]['namaBarang'],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            subtitle: Text(
              transaksiItem[i]['hjBarang'].toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing: Text(
              'Jumlah Stok : ' + transaksiItem[i]['jmlStok'].toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )),
    );
  }
}