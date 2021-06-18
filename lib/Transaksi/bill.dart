import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:ecashier/Transaksi/transaksi.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      this.katBarang,
      this.hjBarang,
      this.hbBarang,
      this.jmlStok,
      this.minStok,
      this.namaSupplier,

      this.index});

  final String namaBarang;
  final String katBarang;
  final String hjBarang;
  final String hbBarang;
  final String jmlStok;
  final String minStok;
  final index;

  final String namaSupplier;
  @override
  _BillPageState createState() => _BillPageState();
}

class BillItem {
  BillItem({this.namaBarang, this.hargaBarang, this.index});

  final String namaBarang;
  final String hargaBarang;
  final index;
}

List<BillItem> items = [];

Map<String, int> countItem = new Map<String, int>();

class _BillPageState extends State<BillPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var itemName;
  var itemPrice;
  var namaBarang;
  var newIndex;
  var jmlStok;
  var intStokLocal;
  var jmlHarga = 0;
  var intPrice;
  var harga;
  var totalHarga;
  bool uangCukup;
  var index;
  DateTime now = DateTime.now();
  String formattedDate;
  TextEditingController uangTerima = TextEditingController();
  var terima;
  var fixTerima;
  var intTerima;

  String diterima;
  String kembali;

  Future<bool> add(List<BillItem> items) async {
    items.map((item){
      DateTime now = DateTime.now();
      // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      Firestore.instance.collection("detailBarang").document(now.toString()).setData({
        'barang' : {
          'namaBarang': item.namaBarang,
        }
      }
      );
    });
  }

  void initState() {
    super.initState();



    jmlStok = widget.jmlStok;
    intStokLocal = int.parse(jmlStok);
    assert(intStokLocal is int);
    intStokLocal = intStokLocal - 1;
    newIndex = widget.index;
    itemName = widget.namaBarang;
    itemPrice = widget.hjBarang;

    var newPrice = itemPrice.substring(2);

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(newIndex);
      await transaction.update(snapshot.reference, {
        'jmlStok': intStokLocal,
      });
    });

    if (countItem.containsKey(itemName)) {
      countItem[itemName] += 1;
    } else {
      countItem[itemName] = 1;
      items.add(BillItem(namaBarang: itemName, hargaBarang: newPrice));
    }
  }



  Iterable<DataRow> mapItemDataRows(List<BillItem> items) {
    Iterable<DataRow> dataRows = items.map((item) {
      var newPrice = item.hargaBarang;
      var fixPrice = newPrice.replaceAll(".", "");
      intPrice = int.parse(fixPrice);
      assert(intPrice is int);
      harga = countItem[item.namaBarang] * intPrice;
      jmlHarga = jmlHarga + harga;



      return DataRow(cells: [
        DataCell(
          Text(
            item.namaBarang,
          ),
        ),
        DataCell(
          Text(intPrice.toString()),
        ),
        DataCell(Text(countItem[item.namaBarang].toString())),
        DataCell(Text((harga).toString())),
        DataCell(TextButton.icon(
          onPressed: () async {
            await Firestore.instance
                .runTransaction((Transaction transaction) async {
              DocumentSnapshot snapshot = await transaction.get(newIndex);
              await transaction.update(snapshot.reference, {
                'jmlStok': intStokLocal + countItem[item.namaBarang],
              });
            });

            jmlHarga = jmlHarga - harga;
            setState(() {
              items.remove(item);
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

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);

    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Tambah Produk'),
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
                            child: Text(jmlHarga.toString()),
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
                                                  height: 200,
                                                  width: 400,
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text('Jumlah Uang Diterima',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                                      Container(height: 20,),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical: 10,
                                                            horizontal: 10),
                                                        child: TextFormField(
                                                          inputFormatters: [
                                                            CurrencyTextInputFormatter(
                                                                locale: 'id',
                                                                decimalDigits:
                                                                0,
                                                                symbol: 'Rp')
                                                          ],
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
                                                          controller:
                                                          uangTerima,
                                                          validator:
                                                              (value) {
                                                            if (uangTerima ==
                                                                null ||
                                                                uangTerima.text.isEmpty) {
                                                              return 'Masukan jumlah uang yang diterima';
                                                            } return null;

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
                                                              child:
                                                              RaisedButton(
                                                                  color: Colors
                                                                      .blue,
                                                                  child:
                                                                  Text(
                                                                    "Bayar",
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

                                                                    setState(
                                                                            () {
                                                                          terima = uangTerima
                                                                              .text
                                                                              .substring(2);
                                                                          fixTerima = terima.replaceAll(
                                                                              ".",
                                                                              "");
                                                                          intTerima =
                                                                              int.parse(fixTerima);
                                                                          assert(intTerima
                                                                          is int);
                                                                        });
                                                                    if (formKey.currentState.validate()){

                                                                      Navigator.of(konteksUTerima).pop();
                                                                      showDialog(context: context,
                                                                          builder:
                                                                              (BuildContext konteksBill) {
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
                                                                                          Text('Transaksi Berhasil',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30), textAlign: TextAlign.center),
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
                                                                                                child: Text('Rp' + jmlHarga.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                                                                                                child: Text('Rp' + (intTerima - jmlHarga).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                                                                                                  child: RaisedButton(
                                                                                                    color: Colors.blue,
                                                                                                    child: Text(
                                                                                                      "OK",
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                                                                                                    ),
                                                                                                    onPressed: () async {
                                                                                                      await add(items);
                                                                                                      // setState(() {
                                                                                                      //   uangTerima.text = '';
                                                                                                      //   jmlHarga=0;
                                                                                                      // });
                                                                                                      // Navigator.of(konteksBill).pop();
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

                                                                    };



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
                                  setState(() {
                                    items.clear();
                                    countItem.clear();
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

  void cekUang() {
    if (intTerima < jmlHarga) {
      uangCukup = false;
    }
    uangCukup = true;
  }
}
