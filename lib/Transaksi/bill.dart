import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:ecashier/Transaksi/transaksi.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bill',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BillPage(),
        ));
  }
}

class BillPage extends StatefulWidget {
  BillPage(
      {this.namaBarang,
      this.hjBarang,
      this.jmlStok,
      this.minStok,
      this.indexBarang});

  final String namaBarang;
  final String hjBarang;
  final String jmlStok;
  final String minStok;
  final String indexBarang;

  @override
  _BillPageState createState() => _BillPageState();
}

class BillItem {
  BillItem(
      {this.namaBarang, this.hjBarang, this.totalPembelian, this.jmlBarang});

  final String namaBarang;
  String hjBarang;
  int jmlBarang;
  String totalPembelian;

  Map<String, dynamic> toMap() {
    return {
      'namaBarang': namaBarang,
      'hjBarang': hjBarang,
      'jmlBarang': jmlBarang,
      'totalPembelian': totalPembelian
    };
  }
}

List<BillItem> items = [];

Map<String, int> countItem = new Map<String, int>();

Map<String, int> countHarga = new Map<String, int>();
var semuaHarga = 0;

class _BillPageState extends State<BillPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var namaBarang;
  var hjBarang;
  var jmlStok;

  var jmlHarga = 0;
  var indeksBarang;
  var harga;
  var totalHarga;

  DateTime now = DateTime.now();
  String formattedDate;
  TextEditingController uangTerima = TextEditingController();

  void initState() {
    super.initState();
    indeksBarang = widget.indexBarang;
    jmlStok = widget.jmlStok;
    namaBarang = widget.namaBarang;
    hjBarang = widget.hjBarang;
    if (countItem.containsKey(namaBarang)) {
      countItem[namaBarang] += 1;
      countHarga[namaBarang] =
          int.parse(hjBarang.toString().substring(2).replaceAll(".", "")) *
              countItem[namaBarang];
      for (int i = 0; i < items.length; i++) {
        if (items[i].namaBarang == namaBarang) {
          items[i].totalPembelian = countHarga[namaBarang].toString();
          items[i].jmlBarang += 1;
        }
      }
    } else {
      countItem[namaBarang] = 1;
      countHarga[namaBarang] =
          int.parse(hjBarang.toString().substring(2).replaceAll(".", ""));
      items.add(BillItem(
          namaBarang: namaBarang,
          hjBarang: hjBarang,
          jmlBarang: countItem[namaBarang],
          totalPembelian: countHarga[namaBarang].toString()));
    }
    semuaHarga +=
        int.parse(hjBarang.toString().substring(2).replaceAll(".", ""));
  }

  Iterable<DataRow> mapItemDataRows(List<BillItem> items) {
    Iterable<DataRow> dataRows = items.map((item) {
      return DataRow(cells: [
        DataCell(
          Text(
            item.namaBarang,
          ),
        ),
        DataCell(
          Text(item.hjBarang),
        ),
        DataCell(Text(item.jmlBarang.toString())),
        DataCell(Text('Rp' + item.totalPembelian)),
        DataCell(TextButton.icon(
          onPressed: () async {
            setState(() {
              semuaHarga -= countHarga[item.namaBarang];
              print(semuaHarga);
              List<String> hasilKey = countItem.keys.toList();
              for (var j = 0; j < hasilKey.length; j++) {
                if (hasilKey[j] == item.namaBarang) {
                  for (int a = 0; a < transaksiItem.length; a++) {
                    if (hasilKey[j] == transaksiItem[a]['namaBarang']) {
                      transaksiItem[a]['jmlStok'] += countItem[item.namaBarang];
                    }
                  }
                }
              }
              ;
              items.remove(item);
              countHarga.remove(item.namaBarang);
              countItem.remove(item.namaBarang);
            });
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          label: Text(
            'Hapus',
            style: TextStyle(color: Colors.red),
          ),
        )),
      ]);
    });
    return dataRows;
  }

  int getStokPakai(namaBarang) {
    for (int a = 0; a < transaksiItem.length; a++) {
      if (namaBarang == transaksiItem[a]['namaBarang']) {
        return transaksiItem[a]['stokPakai'];
      }
    }
    return null;
  }

  // ignore: missing_return
  Future<bool> addTransaksi(int semuaHarga) async {
    List yourItemList = [];
    for (int i = 0; i < items.length; i++) {
      yourItemList.add(items[i].toMap());
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd 00:00:00.000').format(now);
    await Firestore.instance.collection('detailTransaksi').document().setData({
      'tanggalTransaksi': formattedDate,
      'totalHarga': semuaHarga.toString(),
      "Item": FieldValue.arrayUnion(yourItemList),
      "uangDiterima" : uangTerima.text,
      "kembalian" : int.parse(uangTerima.text.toString().substring(2).replaceAll(".", ""))-semuaHarga

    });
  }

  int getNama(namaBarang) {
    for (int a = 0; a < transaksiItem.length; a++) {
      if (namaBarang == transaksiItem[a]['namaBarang']) {
        return transaksiItem[a]['jmlStok'];
      }
    }
    return null;
  }

  String getDocDate(namaBarang) {
    for (int a = 0; a < transaksiItem.length; a++) {
      if (namaBarang == transaksiItem[a]['namaBarang']) {
        return transaksiItem[a]['docDate'];
      }
    }
    return null;
  }

  String outputValidasi = 'Masukan jumlah uang yang diterima';
  String uangKurang = 'Uang tidak memenuhi total pembelian';

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);

    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Transaksi'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Container(height: 30, width: 1200, child: Column()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black,
                      )),
                      height: 100,
                      width: 1250,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                                height: 0.5, width: 1200, child: Column()),
                          ),
                          Text(
                            'TOKO SUSU LARIS JAYA MAGELANG',
                            style: TextStyle(fontSize: 40),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                                height: 1, width: 1200, child: Column()),
                          ),
                          Text(
                            'Jl. Sriwijaya No.58, Rejowinangun Utara, Kec. Magelang Tengah, Kota Magelang, Jawa Tengah 56111',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                ),
                Container(
                  width: 1250,
                  height: 500,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                  )),
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 150.0,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Nama Barang',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 20),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Harga',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 20),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Jumlah',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 20),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total Harga',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 20),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                ' ',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 20),
                              ),
                            ),
                          ],
                          rows: mapItemDataRows(items).toList(),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 1043,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black,
                            )),
                            child: Text(
                              'Total Pembelian',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 205,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black,
                            )),
                            child: Text('Rp' + semuaHarga.toString()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 50,
                              width: 1130,
                              child: ElevatedButton(
                                child: Text(
                                  'Bayar',
                                  style: TextStyle(fontSize: 30),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext konteksUTerima) {
                                        return AlertDialog(
                                          content: Stack(
                                            // ignore: deprecated_member_use
                                            overflow: Overflow.visible,
                                            children: <Widget>[
                                              Form(
                                                key: formKey,
                                                child: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'Jumlah Uang Diterima',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Uang Diterima',
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            CurrencyTextInputFormatter(
                                                                locale: 'id',
                                                                decimalDigits:
                                                                    0,
                                                                symbol: 'Rp')
                                                          ],
                                                          controller:
                                                              uangTerima,
                                                          validator: (value) {
                                                            if (uangTerima ==
                                                                    null ||
                                                                uangTerima.text
                                                                    .isEmpty) {
                                                              return outputValidasi;
                                                            } else if (int.parse(
                                                                    uangTerima
                                                                        .text
                                                                        .substring(
                                                                            2)
                                                                        .replaceAll(
                                                                            ".",
                                                                            "")) <
                                                                semuaHarga) {
                                                              return uangKurang;
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 50,
                                                              width: 180,
                                                              // ignore: deprecated_member_use
                                                              child:
                                                                  // ignore: deprecated_member_use
                                                                  RaisedButton(
                                                                      color: Colors
                                                                          .blue,
                                                                      child:
                                                                          Text(
                                                                        "Bayar Fix",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        print('docDate'+getDocDate(namaBarang));
                                                                        if (formKey
                                                                            .currentState
                                                                            .validate()) {
                                                                          addTransaksi(semuaHarga);

                                                                          List<String>hasilKey = countItem.keys.toList();
                                                                          for (var j = 0; j < hasilKey.length; j++) {
                                                                            var stokPakai = getStokPakai(hasilKey[j]);
                                                                            Firestore.instance.collection('barang').document(getDocDate(namaBarang)).updateData({
                                                                              "jmlStok": getNama(hasilKey[j]),
                                                                            }).then((result) {
                                                                              print("new USer true");
                                                                            }).catchError((onError) {
                                                                              print("onError");
                                                                            });
                                                                            Firestore.instance.collection('barang').document(getDocDate(namaBarang)).updateData({
                                                                              "stokPakai": stokPakai + countItem[hasilKey[j]],
                                                                            }).then((result) {
                                                                              print("new USer true");
                                                                            }).catchError((onError) {
                                                                              print("onError");
                                                                            });
                                                                          }
                                                                          ;

                                                                          Navigator.of(konteksUTerima)
                                                                              .pop();
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext konteksBill) {
                                                                                return AlertDialog(
                                                                                  content: Stack(
                                                                                    // ignore: deprecated_member_use
                                                                                    overflow: Overflow.visible,
                                                                                    children: <Widget>[
                                                                                      Form(
                                                                                        child: Container(
                                                                                          margin: const EdgeInsets.all(10.0),
                                                                                          color: Colors.white,
                                                                                          height: 500,
                                                                                          width: 400,
                                                                                          child: Column(

                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: <Widget>[
                                                                                              Container(
                                                                                                child: Icon(
                                                                                                  Icons.check_circle,
                                                                                                  color: Colors.blue,
                                                                                                  size: 50,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                height: 40,
                                                                                              ),
                                                                                              Text('Transaksi Berhasil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30), textAlign: TextAlign.center),
                                                                                              Text(formattedDate),
                                                                                              Container(
                                                                                                height: 60,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    child: Text(
                                                                                                      "Pembayaran",
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: Text("Tunai", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                              Container(
                                                                                                height: 20,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    child: Text(
                                                                                                      "Total Tagihan",
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: Text('Rp' + semuaHarga.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                              Container(
                                                                                                height: 20,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    child: Text(
                                                                                                      "Diterima",
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: Text(uangTerima.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                              Container(
                                                                                                height: 20,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    child: Text(
                                                                                                      "Kembalian",
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: Text('Rp' + (int.parse(uangTerima.text.substring(2).replaceAll(".", "")) - semuaHarga).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                              Container(
                                                                                                height: 20,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                children: <Widget>[
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: SizedBox(
                                                                                                      height: 50,
                                                                                                      width: 384,
                                                                                                      // ignore: deprecated_member_use
                                                                                                      child: RaisedButton(
                                                                                                        color: Colors.blue,
                                                                                                        child: Text(
                                                                                                          "OK",
                                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                                                                                                        ),
                                                                                                        onPressed: () async {
                                                                                                          getData();
                                                                                                          setState(() {
                                                                                                            uangTerima.text = '';
                                                                                                            jmlHarga = 0;
                                                                                                            semuaHarga = 0;
                                                                                                          });
                                                                                                          Navigator.of(konteksBill).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              });
                                                                        }
                                                                        ;
                                                                        setState(
                                                                            () {
                                                                          items
                                                                              .clear();
                                                                          countItem
                                                                              .clear();
                                                                        });
                                                                      }),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 50,
                                                              width: 180,
                                                              child:
                                                                  // ignore: deprecated_member_use
                                                                  RaisedButton(
                                                                child: Text(
                                                                    "Batal",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .black)),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          konteksUTerima)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              ),
                            ))),
                    Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                child: Text(
                                  '+',
                                  style: TextStyle(fontSize: 30),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new TransaksiPage()));
                                },
                              ),
                            )))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
