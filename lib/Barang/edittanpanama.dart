import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:ecashier/Barang/produk.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';


import '../main.dart';

void main() => runApp(MyApp());
BuildContext konteks;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Edit Barang Tanpa Nama',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: TanpaNamaPage(),
        ));
  }
}

class TanpaNamaPage extends StatefulWidget {
  TanpaNamaPage(
      {this.namaBarang,
        this.katBarang,
        this.hjBarang,
        this.hbBarang,
        this.jmlStok,
        this.minStok,
        this.namaSupplier,
        this.rataPenjualan,
        this.rataPenjualanTinggi,
        this.waktuPesan,
        this.waktuPesanLama,
        this.docDate});


  final String namaBarang;
  final String waktuPesanLama;
  final String waktuPesan;
  final String rataPenjualan;
  final String rataPenjualanTinggi;
  final String katBarang;
  final String hjBarang;
  final String hbBarang;
  final String jmlStok;
  final String minStok;
  final String docDate;

  final String namaSupplier;
  @override
  TanpaNamaPageState createState() => TanpaNamaPageState();
}

class TanpaNamaPageState extends State<TanpaNamaPage> {
  var selectedKategori;
  var selectedSupplier;
  var docDate;

  TextEditingController controllerNama;
  TextEditingController controllerHj;
  TextEditingController controllerHb;
  TextEditingController controllerjmlStok;
  TextEditingController controllerminStok;
  TextEditingController controllerWaktuPesan;
  TextEditingController controllerWaktuPesanLama;
  TextEditingController controllerRataJual;
  TextEditingController controllerRataJualTinggi;

  final _formKey = GlobalKey<FormState>();

  bool jawaban;
  bool hasil;
  bool hasilnya;
  String outputValidasi = "Nama Barang Sudah Terdaftar";

  @override
  void initState() {
    super.initState();
    controllerNama = new TextEditingController(text: widget.namaBarang);
    controllerHj = new TextEditingController(text: widget.hjBarang);
    controllerHb = new TextEditingController(text: widget.hbBarang);
    controllerjmlStok = new TextEditingController(text: widget.jmlStok);
    controllerminStok = new TextEditingController(text: widget.minStok);
    controllerWaktuPesanLama = new TextEditingController(text: widget.waktuPesanLama);
    controllerWaktuPesan = new TextEditingController(text: widget.waktuPesan);
    controllerRataJual = new TextEditingController(text: widget.rataPenjualan);
    controllerRataJualTinggi = new TextEditingController(text: widget.rataPenjualanTinggi);
    selectedKategori = widget.katBarang;
    selectedSupplier = widget.namaSupplier;
    docDate = widget.docDate;

  }

  Future<bool> deleteBarang( BuildContext deleteKonteks) async {
    Firestore.instance.collection('barang').document(widget.docDate).delete().then((result) {
      print("new USer true");
    }).catchError((onError) {
      print("onError");
    });

    return null;
  }


  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Edit Produk'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SizedBox.fromSize(
                    size: Size(1500, 50), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.blue,
                        borderOnForeground: true, // button color
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Edit Produk",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
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
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama Barang',
                    ),
                    enabled: false,
                    controller: controllerNama,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('kategori').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Tidak bisa mendapatkan data");
                      } else {
                        List<DropdownMenuItem> kategoriItems = [];
                        for (int i = 0; i < snapshot.data.documents.length; i++) {
                          DocumentSnapshot snap = snapshot.data.documents[i];
                          kategoriItems.add(DropdownMenuItem(
                            child: Text(
                              snap.data['namaKategori'],
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.data['namaKategori']}",
                          ));
                        }
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Kategori Barang'),
                              value: selectedKategori,
                              items: kategoriItems,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kategori Barang Wajib Diisi';
                                }
                                return null;
                              },
                              onChanged: (kategoriValue) {
                                setState(() {
                                  selectedKategori = kategoriValue;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Harga Jual Barang',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'id', decimalDigits: 0, symbol: 'Rp')
                      ],
                      controller: controllerHj,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga Jual Wajib Diisi';
                        }else if (int.parse(controllerHb
                            .text
                            .substring(
                            2)
                            .replaceAll(
                            ".",
                            "")) >
                            int.parse(controllerHj
                                .text
                                .substring(
                                2)
                                .replaceAll(
                                ".",
                                ""))) {
                          return 'Harga Jual kurang dari Harga Beli';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Harga Beli Barang'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'id', decimalDigits: 0, symbol: 'Rp')
                      ],
                      controller: controllerHb,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga Beli Wajib Diisi';
                        }else if (int.parse(controllerHb
                            .text
                            .substring(
                            2)
                            .replaceAll(
                            ".",
                            "")) >
                            int.parse(controllerHj
                                .text
                                .substring(
                                2)
                                .replaceAll(
                                ".",
                                ""))) {
                          return 'Harga Beli lebih dari Harga Jual';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Jumlah Stok'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: controllerjmlStok,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah Stok Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Minimum Stok'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: controllerminStok,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Minimal Stok  Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream:
                    Firestore.instance.collection('supplier').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Tidak bisa mendapatkan data");
                      } else {
                        List<DropdownMenuItem> supplierItems = [];
                        for (int i = 0;
                        i < snapshot.data.documents.length;
                        i++) {
                          DocumentSnapshot snap = snapshot.data.documents[i];
                          supplierItems.add(DropdownMenuItem(
                            child: Text(
                              snap.data['namaSupplier'],
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.data['namaSupplier']}",
                          ));
                        }
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Supplier Barang'),
                              value: selectedSupplier,
                              items: supplierItems,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Supplier Barang Wajib Diisi';
                                }
                                return null;
                              },
                              onChanged: (supplierValue) {
                                setState(() {
                                  selectedSupplier = supplierValue;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Rata Penjualan / Hari'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: controllerRataJual,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Rata Penjualan Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Rata Penjualan Tertinggi / Hari'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: controllerRataJualTinggi,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Rata Penjualan Tertinggi Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Waktu Pemesanan'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: controllerWaktuPesan,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu Pemesanan Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Waktu Pemesanan Terlama'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: controllerWaktuPesanLama,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu Pemesanan Terlama Wajib Diisi';
                        }
                        return null;
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () async {

                          if (_formKey.currentState.validate()) {
                            print(widget.namaBarang);
                            Firestore.instance.collection('barang').document(widget.docDate).updateData({
                              "kategoriBarang": selectedKategori,
                              "hbBarang": controllerHb.text,
                              "hjBarang": controllerHj.text,
                              "kategoriBarang": selectedKategori,
                              "minStok": controllerminStok.text,
                              "namaSupplier": selectedSupplier,
                              "rataPenjualan": controllerRataJual.text,
                              "rataPenjualanTinggi": controllerRataJualTinggi.text,
                              "waktuPesan": controllerWaktuPesan.text,
                              "waktuPesanLama": controllerWaktuPesanLama.text,
                              "jmlStok": controllerjmlStok.text,
                            }).then((result) {
                              print("new USer true");
                            }).catchError((onError) {
                              print(onError);
                            });


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
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Apakah benar anda ingin melakukan update data barang?",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 180,
                                                      // ignore: deprecated_member_use
                                                      child: RaisedButton(
                                                        color: Colors.blue,
                                                        child: Text("Ya",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.white),),
                                                        onPressed: () {
                                                      setState(() {
                                                        getData();
                                                      });

                                  Navigator.of(editKonteks).pop();
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukPage(),));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 180,
                                                      // ignore: deprecated_member_use
                                                      child: RaisedButton(
                                                        color: Colors.red,
                                                        child: Text("Tidak",
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
                                                ]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          };
                        },
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Simpan',
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
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext deleteKonteks) {
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
                                              "Apakah benar anda ingin menghapus barang" +
                                                  ' ' +
                                                  controllerNama.text +
                                                  "?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 180,
                                                    // ignore: deprecated_member_use
                                                    child: RaisedButton(
                                                      color: Colors.red,
                                                      child: Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 20,
                                                            color:
                                                            Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        await deleteBarang(deleteKonteks);
                                                        await Navigator.of(deleteKonteks).pop();
                                                        await getData();
                                                        Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) => new ProdukPage(),
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
                                                      child: Text("Batal",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .black)),
                                                      onPressed: () {
                                                        Navigator.of(
                                                            deleteKonteks)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        color: Colors.redAccent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Hapus',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
