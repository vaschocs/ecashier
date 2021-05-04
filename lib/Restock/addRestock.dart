import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());
BuildContext konteks;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tambah Stok Barang',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: TambahStok(),
        ));
  }
}

class TambahStok extends StatefulWidget {
  TambahStok(
      {this.namaBarang,
      this.katBarang,
      this.hjBarang,
      this.hbBarang,
      this.jmlStok,
      this.minStok,
      this.satuan,
      this.index});

  final String namaBarang;
  final String katBarang;
  final String hjBarang;
  final String hbBarang;
  final String jmlStok;
  final String minStok;
  final index;
  final String satuan;
  @override
  _TambahStokPage createState() => _TambahStokPage();
}

class _TambahStokPage extends State<TambahStok> {
  var selectedKategori;
  var selectedSatuan;
  var indeks;

  TextEditingController controllerNama;
  TextEditingController controllerHj;
  TextEditingController controllerHb;
  TextEditingController controllerjmlStok;
  TextEditingController controllerminStok;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controllerNama = new TextEditingController(text: widget.namaBarang);
    controllerHj = new TextEditingController(text: widget.hjBarang);
    controllerHb = new TextEditingController(text: widget.hbBarang);
    controllerjmlStok = new TextEditingController(text: widget.jmlStok);
    controllerminStok = new TextEditingController(text: widget.minStok);
    selectedKategori = widget.katBarang;
    selectedSatuan = widget.satuan;
    indeks = widget.index;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Tambah Stok'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SizedBox.fromSize(
                  size: Size(400, 30), // button width and height
                  child: ClipRect(
                    child: Material(
                      color: Colors.green,
                      borderOnForeground: true, // button color
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Keterangan Produk",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextFormField(
                  enabled: false,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nama Barang'),
                  autofocus: true,
                  controller: controllerNama,
                  validator: (value) {},
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Harga Jual Barang',
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controllerHj,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Harga Beli Barang'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controllerHb,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SizedBox.fromSize(
                  size: Size(400, 30), // button width and height
                  child: ClipRect(
                    child: Material(
                      color: Colors.green,
                      borderOnForeground: true, // button color
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Tambah Stok",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Jumlah Stok'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controllerjmlStok,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Minimum Stok'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controllerminStok,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: RaisedButton(
                  onPressed: () async {
                    // await doesNameAlreadyExist();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => KelolaBarangPage(),
                    //   ),
                    // );
                  },
                  color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
