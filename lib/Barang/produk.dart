import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:ecashier/Barang/edittanpanama.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'editBarang.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelola Barang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ProdukPage(),
    );
  }
}

List<Map> _search = [];


class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {

  var selectedKategori, selectedSupplier;

  bool sama;

  String outputValidasi = "Nama Barang Sudah Terdaftar";

  TextEditingController namaBarang = TextEditingController();
  TextEditingController katBarang = TextEditingController();
  TextEditingController hjBarang = TextEditingController();
  TextEditingController hbBarang = TextEditingController();
  TextEditingController jmlStok = TextEditingController();
  TextEditingController minStok = TextEditingController();
  TextEditingController namaSupplier = TextEditingController();
  TextEditingController waktuPesan = TextEditingController();
  TextEditingController waktuPesanLama = TextEditingController();
  TextEditingController rataPenjualan = TextEditingController();
  TextEditingController rataPenjualanTinggi = TextEditingController();
  TextEditingController searchBar = new TextEditingController();

  onSearch(String text) async {

    _search.clear();
    if (text.isEmpty) {
      for (int i = 0; i < transaksiItem.length; i++) {
          setState(() {
            Map document = new Map();
            document['hbBarang'] = transaksiItem[i]['hbBarang'];
            document['docDate'] = transaksiItem[i]['docDate'];
            document['hjBarang'] = transaksiItem[i]['hjBarang'];
            document['jmlStok'] = transaksiItem[i]['jmlStok'];
            document['jmlStok'] = transaksiItem[i]['jmlStok'];
            document['kategoriBarang'] = transaksiItem[i]['kategoriBarang'];
            document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
            document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
            document['minStok'] =transaksiItem[i] ['minStok'];
            document['namaBarang'] = transaksiItem[i]['namaBarang'];
            document['namaSupplier'] =transaksiItem[i] ['namaSupplier'];
            document['rataPenjualan'] =transaksiItem[i] ['rataPenjualan'];
            document['rataPenjualanTinggi'] = transaksiItem[i]['rataPenjualanTinggi'];
            document['stokAwal'] =transaksiItem[i] ['stokAwal'];
            document['stokPakai'] =transaksiItem[i] ['stokPakai'];
            document['tanggalPergerakan'] = transaksiItem[i]['tanggalPergerakan'];
            document['waktu'] = transaksiItem[i]['waktu'];
            document['waktuPesan'] = transaksiItem[i]['waktuPesan'];
            document['waktuPesanLama'] = transaksiItem[i]['waktuPesanLama'];
            _search.add(document);
          });


      }
      return;
    }

    for (int i = 0; i < transaksiItem.length; i++) {
      if (transaksiItem[i]['namaBarang'].toString().contains(text) ||transaksiItem[i]['kategoriBarang'].toString().contains(text)  ) {
       setState(() {
         Map document = new Map();
         document['hbBarang'] = transaksiItem[i]['hbBarang'];
         document['hjBarang'] = transaksiItem[i]['hjBarang'];
         document['docDate'] = transaksiItem[i]['docDate'];
         document['jmlStok'] = transaksiItem[i]['jmlStok'];
         document['jmlStok'] = transaksiItem[i]['jmlStok'];
         document['kategoriBarang'] = transaksiItem[i]['kategoriBarang'];
         document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
         document['kategoriPergerakan'] = transaksiItem[i]['kategoriPergerakan'];
         document['minStok'] =transaksiItem[i] ['minStok'];
         document['namaBarang'] = transaksiItem[i]['namaBarang'];
         document['namaSupplier'] =transaksiItem[i] ['namaSupplier'];
         document['rataPenjualan'] =transaksiItem[i] ['rataPenjualan'];
         document['rataPenjualanTinggi'] = transaksiItem[i]['rataPenjualanTinggi'];
         document['stokAwal'] =transaksiItem[i] ['stokAwal'];
         document['stokPakai'] =transaksiItem[i] ['stokPakai'];
         document['tanggalPergerakan'] = transaksiItem[i]['tanggalPergerakan'];
         document['waktu'] = transaksiItem[i]['waktu'];
         document['waktuPesan'] = transaksiItem[i]['waktuPesan'];
         document['waktuPesan'] = transaksiItem[i]['waktuPesan'];
         document['waktuPesanLama'] = transaksiItem[i]['waktuPesanLama'];
         _search.add(document);

       });
      }
    }
  }

  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  // ignore: missing_return
  Future<bool> cekBarang(String value) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('barang')
        .where('namaBarang', isEqualTo: value)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length >= 1) {
      // ignore: await_only_futures
      await setState(() {
        sama = true;
      });
    } else {
      setState(() {
        sama = false;
      });
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text('Kelola Produk'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchBar,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.cancel),
                          iconSize: 20.0,
                          onPressed: () {
                           searchBar.clear();
                          },
                        ),
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 20.0,
                          onPressed: () {},
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: "Cari Produk",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0)))),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                ),
                width: 1250,
                height: 630,
                child:
                _search.length != 0 || searchBar.text.isNotEmpty
                    ? ListView.builder(
                  itemCount: _search.length,
                  itemBuilder: (context, i) {
                    final b = _search[i];
                    return new Container(
                      child: Card(
                          color: int.parse(b['jmlStok'].toString()) == 0
                              ? Colors.grey.shade300
                              : int.parse(b['minStok'].toString()) <=
                              int.parse(b['jmlStok'].toString())
                              ? Colors.lightBlue[100]
                              : Colors.redAccent[100],
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext editKonteks) {
                                    return AlertDialog(
                                      content: Stack(
                                        // ignore: deprecated_member_use
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Apakah anda ingin melakukan update pada Nama barang?",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 30,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            height: 50,
                                                            width: 180,
                                                            // ignore: deprecated_member_use
                                                            child: RaisedButton(
                                                              color: Colors.blue,
                                                              child: Text(
                                                                "Ya",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 20,
                                                                    color: Colors.white),
                                                              ),
                                                              onPressed: () {

                                                                Navigator.of(editKonteks).pop();
                                                                Navigator.push(context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          EditBarangPage(
                                                                              namaBarang: b['namaBarang'],
                                                                              hjBarang: b['hjBarang'],
                                                                              minStok: b['minStok'].toString(),
                                                                              katBarang: b['kategoriBarang'],
                                                                              hbBarang: b['hbBarang'],
                                                                              jmlStok: b['jmlStok'].toString(),
                                                                              namaSupplier: b['namaSupplier'],
                                                                              docDate: b['docDate'],
                                                                              rataPenjualan: b['rataPenjualan'].toString(),
                                                                              rataPenjualanTinggi: b['rataPenjualanTinggi'].toString(),
                                                                              waktuPesan: b['waktuPesan'].toString(),
                                                                              waktuPesanLama: b['waktuPesanLama'].toString(),

                                                                          ),
                                                                    ));
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            height: 50,
                                                            width: 180,
                                                            // ignore: deprecated_member_use
                                                            child: RaisedButton(
                                                              color: Colors.blue,
                                                              child: Text(
                                                                "Tidak",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 20,
                                                                    color: Colors.white),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(editKonteks)
                                                                    .pop();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          TanpaNamaPage(
                                                                            namaBarang: b['namaBarang'],
                                                                            hjBarang: b['hjBarang'],
                                                                            minStok: b['minStok'].toString(),
                                                                            katBarang: b['kategoriBarang'],
                                                                            hbBarang: b['hbBarang'],
                                                                            jmlStok: b['jmlStok'].toString(),
                                                                            namaSupplier: b['namaSupplier'],
                                                                            docDate: b['docDate'],
                                                                            rataPenjualan: b['rataPenjualan'].toString(),
                                                                            rataPenjualanTinggi: b['rataPenjualanTinggi'].toString(),
                                                                            waktuPesan: b['waktuPesan'].toString(),
                                                                            waktuPesanLama: b['waktuPesanLama'].toString(),
                                                                          ),
                                                                    ));
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 180,
                                                      // ignore: deprecated_member_use
                                                      child: RaisedButton(
                                                        color: Colors.red,
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(editKonteks).pop();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            leading: Icon(
                              int.parse(b['minStok'].toString()) <=
                                  int.parse(b['jmlStok'].toString())
                                  ? Icons.format_list_bulleted
                                  : Icons.report,
                              color: Colors.black,
                            ),
                            title: Text(
                              b['namaBarang'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              b['hjBarang'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            trailing: Text(
                              'Jumlah Stok : ' + b['jmlStok'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )),
                    );
                  },
                )
                    :
                ListView.builder(
                  itemCount: transaksiItem.length,
                  itemBuilder: (context,i){
                    return new Container(
                      child: Card(
                          color: int.parse(transaksiItem[i]['jmlStok'].toString()) == 0
                              ? Colors.grey.shade300
                              : int.parse(transaksiItem[i]['minStok'].toString()) <=
                              int.parse(transaksiItem[i]['jmlStok'].toString())
                              ? Colors.lightBlue[100]
                              : Colors.redAccent[100],
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext editKonteks) {
                                    return AlertDialog(
                                      content: Stack(
                                        // ignore: deprecated_member_use
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Apakah anda ingin melakukan update pada Nama barang?",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 30,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            height: 50,
                                                            width: 180,
                                                            // ignore: deprecated_member_use
                                                            child: RaisedButton(
                                                              color: Colors.blue,
                                                              child: Text(
                                                                "Ya",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 20,
                                                                    color: Colors.white),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(editKonteks)
                                                                    .pop();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          EditBarangPage(
                                                                              namaBarang:
                                                                              transaksiItem[i]['namaBarang'],
                                                                              hjBarang:
                                                                              transaksiItem[i]['hjBarang'],
                                                                              minStok: transaksiItem[i]['minStok'].toString(),
                                                                              katBarang:
                                                                              transaksiItem[i]['kategoriBarang'],
                                                                              hbBarang:
                                                                              transaksiItem[i]['hbBarang'],
                                                                              jmlStok: transaksiItem[i]['jmlStok'].toString(),
                                                                              namaSupplier:
                                                                              transaksiItem[i]['namaSupplier'],
                                                                              docDate: transaksiItem[i]['docDate']

                                                                          ),
                                                                    ));
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            height: 50,
                                                            width: 180,
                                                            // ignore: deprecated_member_use
                                                            child: RaisedButton(
                                                              color: Colors.blue,
                                                              child: Text(
                                                                "Tidak",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 20,
                                                                    color: Colors.white),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(editKonteks)
                                                                    .pop();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          TanpaNamaPage(
                                                                              namaBarang:
                                                                              transaksiItem[i]['namaBarang'],
                                                                              hjBarang:
                                                                              transaksiItem[i]['hjBarang'],
                                                                              minStok: transaksiItem[i]['minStok'].toString(),
                                                                              katBarang:
                                                                              transaksiItem[i]['kategoriBarang'],
                                                                              hbBarang:
                                                                              transaksiItem[i]['hbBarang'],
                                                                              jmlStok: transaksiItem[i]['jmlStok'].toString(),
                                                                              namaSupplier:
                                                                              transaksiItem[i]['namaSupplier'],
                                                                              docDate: transaksiItem[i]['docDate']

                                                                          ),
                                                                    ));
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 180,
                                                      // ignore: deprecated_member_use
                                                      child: RaisedButton(
                                                        color: Colors.red,
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(editKonteks).pop();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
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
                  },

                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 1250,
                height: 50,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Tambah',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext konteksAdd) {
                          return AlertDialog(
                            content: Stack(
                              // ignore: deprecated_member_use
                              overflow: Overflow.visible,
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Form(
                                    key: formKey2,
                                    child: Container(
                                      width: 900,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                              child: Container(
                                                alignment: Alignment.center,
                                                color: Colors.lightBlue[200],
                                                width: 1200,
                                                height: 40,
                                                child: Text(
                                                  'Tambah Barang',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              )),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Nama Barang'),
                                              controller: namaBarang,
                                              validator: (namaBarang) {
                                                if (namaBarang == null ||
                                                    namaBarang.isEmpty) {
                                                  return 'Masukan Nama Barang';
                                                } else {
                                                  cekBarang(namaBarang);
                                                  if (sama == true) {
                                                    return outputValidasi;
                                                  } else if (sama == false) {
                                                    return null;
                                                  }
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: Firestore.instance
                                                  .collection('kategori')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                      "Tidak bisa mendapatkan data");
                                                } else {
                                                  List<DropdownMenuItem>
                                                      kategoriItems = [];
                                                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                                                    DocumentSnapshot snap = snapshot.data.documents[i];
                                                    kategoriItems
                                                        .add(DropdownMenuItem(
                                                      child: Text(
                                                        snap.data[
                                                            'namaKategori'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      value:
                                                          "${snap.data['namaKategori']}",
                                                    ));
                                                  }
                                                  return Container(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 10),
                                                      child:
                                                          DropdownButtonFormField(
                                                        decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Kategori Barang'),
                                                        value: selectedKategori,
                                                        items: kategoriItems,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Kategori Barang Wajib Diisi';
                                                          }
                                                          return null;
                                                        },
                                                        onChanged:
                                                            (kategoriValue) {
                                                          setState(() {
                                                            selectedKategori =
                                                                kategoriValue;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Harga Beli Barang'),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Harga Beli Wajib Diisi';
                                                } else if (int.parse(hbBarang
                                                        .text
                                                        .substring(2)
                                                        .replaceAll(".", "")) >
                                                    int.parse(hjBarang.text
                                                        .substring(2)
                                                        .replaceAll(".", ""))) {
                                                  return 'Harga Jual kurang dari Harga Beli';
                                                }

                                                return null;
                                              },
                                              inputFormatters: [
                                                CurrencyTextInputFormatter(
                                                    locale: 'id',
                                                    decimalDigits: 0,
                                                    symbol: 'Rp')
                                              ],
                                              controller: hbBarang,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Harga Jual Barang',
                                              ),
                                              inputFormatters: [
                                                CurrencyTextInputFormatter(
                                                    locale: 'id',
                                                    decimalDigits: 0,
                                                    symbol: 'Rp')
                                              ],
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Harga Jual Wajib Diisi';
                                                } else if (int.parse(hbBarang
                                                        .text
                                                        .substring(2)
                                                        .replaceAll(".", "")) >
                                                    int.parse(hjBarang.text
                                                        .substring(2)
                                                        .replaceAll(".", ""))) {
                                                  return 'Harga Beli Melebihi Harga Jual';
                                                }
                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: hjBarang,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Jumlah Stok'),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: jmlStok,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Stok Barang Wajib Diisi';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: Firestore.instance
                                                  .collection('supplier')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                      "Tidak bisa mendapatkan data");
                                                } else {
                                                  List<DropdownMenuItem>
                                                      supplierItems = [];
                                                  for (int i = 0;
                                                      i <
                                                          snapshot.data
                                                              .documents.length;
                                                      i++) {
                                                    DocumentSnapshot snap =
                                                        snapshot
                                                            .data.documents[i];
                                                    supplierItems
                                                        .add(DropdownMenuItem(
                                                      child: Text(
                                                        snap.data[
                                                            'namaSupplier'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      value:
                                                          "${snap.data['namaSupplier']}",
                                                    ));
                                                  }
                                                  return Container(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 10),
                                                      child:
                                                          DropdownButtonFormField(
                                                        decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Supplier Barang'),
                                                        value: selectedSupplier,
                                                        items: supplierItems,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Supplier Barang Wajib Diisi';
                                                          }
                                                          return null;
                                                        },
                                                        onChanged:
                                                            (supplierValue) {
                                                          setState(() {
                                                            selectedSupplier =
                                                                supplierValue;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Waktu Pemesanan'),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: waktuPesan,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Waktu Pemesanan Wajib Diisi';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Waktu Pemesanan Terlama'),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: waktuPesanLama,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Waktu Pemesanan Terlama Wajib Diisi';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Rata- Rata Penjualan'),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: rataPenjualan,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Rata- Rata Penjualan Wajib Diisi';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Rata - Rata Penjualan Tertinggi'),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: rataPenjualanTinggi,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Rata - Rata Penjualan Tertinggi Wajib Diisi';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                // ignore: deprecated_member_use
                                                child:
                                                    // ignore: deprecated_member_use
                                                    RaisedButton(
                                                  onPressed: () async {
                                                    DateTime now =
                                                        DateTime.now();
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(now);
                                                    DateTime doc =
                                                        DateTime.now();
                                                    String docDate = DateFormat(
                                                            'yyyy-MM-dd hh:mm:ss')
                                                        .format(doc);
                                                    if (formKey2.currentState
                                                        .validate()) {
                                                     setState(() {
                                                       Firestore.instance
                                                           .collection("barang")
                                                           .document(docDate)
                                                           .setData({
                                                         'namaBarang':
                                                         namaBarang.text,
                                                         'kategoriBarang':
                                                         selectedKategori,
                                                         'namaSupplier':
                                                         selectedSupplier,
                                                         'hjBarang':
                                                         hjBarang.text,
                                                         'hbBarang':
                                                         hbBarang.text,
                                                         'jmlStok': jmlStok.text,
                                                         'stokAwal':
                                                         jmlStok.text,
                                                         'minStok': 0,
                                                         'waktu': formattedDate,
                                                         'kategoriPergerakan':
                                                         'belum ada',
                                                         'tanggalPergerakan':
                                                         'belum ada',
                                                         'stokPakai': 0,
                                                         'waktuPesan':
                                                         waktuPesan.text,
                                                         'docDate': docDate,
                                                         'waktuPesanLama':
                                                         waktuPesanLama.text,
                                                         'rataPenjualan':
                                                         rataPenjualan.text,
                                                         'rataPenjualanTinggi':
                                                         rataPenjualanTinggi
                                                             .text,
                                                       });
                                                       namaBarang.text = '';
                                                       selectedKategori = null;
                                                       hjBarang.text = '';
                                                       hbBarang.text = '';
                                                       jmlStok.text = '';
                                                       selectedSupplier = null;
                                                       minStok.text = '';
                                                       formattedDate = '';
                                                       waktuPesan.text = '';
                                                       waktuPesanLama.text = '';
                                                       rataPenjualan.text = '';
                                                       rataPenjualanTinggi.text =
                                                       '';
                                                     });

                                                      Navigator.of(konteksAdd)
                                                          .pop();
                                                      await getData();
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProdukPage(),
                                                          ));
                                                      final snackBar = SnackBar(
                                                          content: Text(
                                                              'Data barang berhasil ditambahkan'));
                                                      ScaffoldMessenger.of(
                                                              konteksAdd)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  },
                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Simpan',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                // ignore: deprecated_member_use
                                                child:
                                                    // ignore: deprecated_member_use
                                                    RaisedButton(
                                                  onPressed: () async {

                                                    namaBarang.text = '';
                                                    selectedKategori = null;
                                                    hjBarang.text = '';
                                                    hbBarang.text = '';
                                                    jmlStok.text = '';
                                                    selectedSupplier = null;
                                                    minStok.text = '';
                                                    waktuPesan.text = '';
                                                    waktuPesan.text = '';
                                                    rataPenjualan.text = '';
                                                    rataPenjualanTinggi.text = '';
// ignore: await_only_futures
                                                    Navigator.of(konteksAdd)
                                                        .pop();
                                                  },
                                                  color: Colors.red,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Batal',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
