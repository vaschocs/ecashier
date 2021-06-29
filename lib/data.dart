import 'package:ecashier/Transaksi/bill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          color: int.parse(TransaksiItem[i]['jmlStok'].toString()) == 0
              ? Colors.grey.shade300
              : int.parse(TransaksiItem[i]['minStok'].toString()) <=
                      int.parse(TransaksiItem[i]['jmlStok'].toString())
                  ? Colors.lightBlue[100]
                  : Colors.redAccent[100],
          child: ListTile(
            onTap: () {
              if (int.parse(TransaksiItem[i]['jmlStok'].toString()) == 0) {
              } else {
                setState(() {
                  TransaksiItem[i]['jmlStok'] =
                      int.parse(TransaksiItem[i]['jmlStok'].toString()) - 1;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillPage(
                        namaBarang: TransaksiItem[i]['namaBarang'],
                        minStok: TransaksiItem[i]['minStok'].toString(),
                        jmlStok: TransaksiItem[i]['jmlStok'].toString(),
                        hbBarang: TransaksiItem[i]['hbBarang'].toString(),
                      ),
                    ));
              }
            },
            leading: Icon(
              int.parse(TransaksiItem[i]['minStok'].toString()) <=
                      int.parse(TransaksiItem[i]['jmlStok'].toString())
                  ? Icons.format_list_bulleted
                  : Icons.report,
              color: Colors.black,
            ),
            title: Text(
              TransaksiItem[i]['namaBarang'],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            subtitle: Text(
              TransaksiItem[i]['hbBarang'].toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing: Text(
              'Jumlah Stok : ' + TransaksiItem[i]['jmlStok'].toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )),
    );
  }
}

