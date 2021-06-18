import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:ecashier/Barang/editBarang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

var gantiNama = true;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ProdukPage(),
    );
  }
}

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  void initState() {
    super.initState();
  }

  void showingNotif() {
    if (berhasil == true) {
      final snackBar =
          SnackBar(content: Text('Nama Kategori Berhasil Ditambahkan'));
      ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
    }
  }

  var selectedKategori;

  var selectedSupplier;
  String outputValidasi = "Nama Barang Sudah Terdaftar";

  bool sama;
  TextEditingController namaBarang = TextEditingController();
  TextEditingController katBarang = TextEditingController();
  TextEditingController hjBarang = TextEditingController();
  TextEditingController hbBarang = TextEditingController();
  TextEditingController jmlStok = TextEditingController();

  TextEditingController minStok = TextEditingController();
  TextEditingController namaSupplier = TextEditingController();
  TextEditingController leadTime = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<bool> cek(String value) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd 00:00:00.000').format(now);
    final QuerySnapshot result = await Firestore.instance
        .collection('barang')
        .where('namaBarang', isEqualTo: value)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length >= 1) {
      await setState(() {
        sama = true;
      });
    } else {
      Firestore.instance
          .collection("barang")
          .document(namaBarang.text)
          .setData({
        'namaBarang': namaBarang.text,
        'kategoriBarang': selectedKategori,
        'namaSupplier': selectedSupplier,
        'hjBarang': hjBarang.text,
        'hbBarang': hbBarang.text,
        'jmlStok': jmlStok.text,
        'stokAwal': jmlStok.text,
        'minStok': minStok.text,
        'waktu': formattedDate,
        'leadTime': leadTime.text
      });
      namaBarang.text = '';

      selectedKategori = null;
      hjBarang.text = '';
      hbBarang.text = '';
      jmlStok.text = '';
      selectedSupplier = null;
      minStok.text = '';
      formattedDate = '';
      leadTime.text = '';
      await setState(() {
        sama = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('barang').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return new Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            );
          return new Container(
              child: TaskList(
            document: snapshot.data.documents,
          ));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext konteksAdd) {
                return AlertDialog(
                  title: Text('Tambah Barang'),
                  content: Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Container(
                            width: 900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
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
                                        cek(namaBarang);
                                        if (sama == true) {
                                          return outputValidasi;
                                        } else if (sama == false) {
                                          setState(() {
                                            namaBarang = '';
                                          });
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
                                        List<DropdownMenuItem> kategoriItems =
                                            [];
                                        for (int i = 0;
                                            i < snapshot.data.documents.length;
                                            i++) {
                                          DocumentSnapshot snap =
                                              snapshot.data.documents[i];
                                          kategoriItems.add(DropdownMenuItem(
                                            child: Text(
                                              snap.data['namaKategori'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            value:
                                                "${snap.data['namaKategori']}",
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
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Kategori Barang Wajib Diisi';
                                                }
                                                return null;
                                              },
                                              onChanged: (kategoriValue) {
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
                                      labelText: 'Harga Jual Barang',
                                    ),
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(
                                          locale: 'id',
                                          decimalDigits: 0,
                                          symbol: 'Rp')
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Harga Jual Wajib Diisi';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: hjBarang,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Harga Beli Barang'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Harga Beli Wajib Diisi';
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
                                        labelText: 'Jumlah Stok'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: jmlStok,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Stok Barang Wajib Diisi';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Waktu Pemesanan',
                                    ),
                                    controller: leadTime,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
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
                                        List<DropdownMenuItem> supplierItems =
                                            [];
                                        for (int i = 0;
                                            i < snapshot.data.documents.length;
                                            i++) {
                                          DocumentSnapshot snap =
                                              snapshot.data.documents[i];
                                          supplierItems.add(DropdownMenuItem(
                                            child: Text(
                                              snap.data['namaSupplier'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            value:
                                                "${snap.data['namaSupplier']}",
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
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Supplier Barang Wajib Diisi';
                                                }
                                                return null;
                                              },
                                              onChanged: (supplierValue) {
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        onPressed: () async {
                                          if (formKey.currentState.validate()) {
                                            Navigator.of(konteksAdd).pop();
                                          }
                                        },
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      // ignore: deprecated_member_use
                                      child: RaisedButton(
                                        onPressed: () async {
                                          Navigator.of(konteksAdd).pop();
                                        },
                                        color: Colors.red,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Batal',
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
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => TambahBarangPage(),
          //     ));
        },
        label: Text('Tambah'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;

  final _formKey = GlobalKey<FormState>();

  bool jawaban;
  bool hasilnya;

  String outputValidasi = "Nama Barang Sudah Terdaftar";

  Future<bool> deleteBarang(
      DocumentReference index, BuildContext deleteKonteks) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(index);
      await transaction.delete(snapshot.reference);

      await Navigator.of(deleteKonteks).pop();

      jawaban = true;
    });
  }

  @override
  Widget build(BuildContext contextEdit) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (
        BuildContext context,
        int i,
      ) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String hjBarang = document[i].data['hjBarang'].toString();
        String minStok = document[i].data['minStok'].toString();
        String katBarang = document[i].data['kategoriBarang'].toString();
        String hbBarang = document[i].data['hbBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        String namaSupplier = document[i].data['namaSupplier'].toString();
        String leadTime = document[i].data['leadTime'].toString();
        TextEditingController controllerNama =
            TextEditingController(text: namaBarang);
        TextEditingController controllerHj =
            TextEditingController(text: hjBarang);
        TextEditingController controllerHb =
            TextEditingController(text: hbBarang);
        TextEditingController controllerjmlStok =
            TextEditingController(text: jmlStok);
        TextEditingController controllerminStok =
            TextEditingController(text: minStok);
        final index = document[i].reference;

        var selectedKategoriEdit  = katBarang;
        var selectedSupplierEdit = namaSupplier;

        Future<bool> update(DocumentReference index, String value) async {
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd – hh:mm:ss').format(now);
          final QuerySnapshot result = await Firestore.instance
              .collection('barang')
              .where('namaBarang', isEqualTo: controllerNama.text)
              .limit(1)
              .getDocuments();
          final List<DocumentSnapshot> document = result.documents;
          if (gantiNama == false) {
              berhasil = true;
              Firestore.instance.runTransaction((Transaction transaction) async {
                DocumentSnapshot snapshot = await transaction.get(
                    index);
                await transaction.update(snapshot.reference, {
                  'namaBarang': controllerNama.text,
                  'kategoriBarang': selectedKategoriEdit,
                  'namaSupplier': selectedSupplierEdit,
                  'hjBarang': controllerHj.text,
                  'hbBarang': controllerHb.text,
                  'jmlStok': controllerjmlStok.text,
                  'minStok': controllerminStok.text,
                  'waktu': formattedDate,
                });
              });

            return null;
          }
            else {
              if(document.length>=1){
                hasil = true;
              }else{
                hasil = false;
                berhasil = true;
                Firestore.instance.runTransaction((Transaction transaction) async {
                  DocumentSnapshot snapshot = await transaction.get(index);
                  await transaction.update(snapshot.reference, {'namaBarang': controllerNama.text,
                    'kategoriBarang': selectedKategoriEdit,
                    'namaSupplier': selectedSupplierEdit,
                    'hjBarang': controllerHj.text,
                    'hbBarang': controllerHb.text,
                    'jmlStok': controllerjmlStok.text,
                    'minStok': controllerminStok.text,
                    'waktu': formattedDate,});

                  final snackBar =
                  SnackBar(content: Text('Nama Kategori berhasil diubah'));
                  ScaffoldMessenger.of(konteks).showSnackBar(snackBar);
                });
              }
              return null;
          }
          return null;
        }

        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.white60,
            child: Card(
                shape: Border.all(color: Colors.blue),
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext editKonteks) {
                          new TaskList();
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 180,
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
                                                      gantiNama = true;
                                                      Navigator.of(editKonteks)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          konteksUpdate) {
                                                            return AlertDialog(
                                                              content: Stack(
                                                                // ignore: deprecated_member_use
                                                                overflow: Overflow
                                                                    .visible,
                                                                children: <Widget>[
                                                                  SingleChildScrollView(
                                                                    child: Form(
                                                                      key: _formKey,
                                                                      child:
                                                                      Container(
                                                                        child:
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              SizedBox.fromSize(
                                                                                size:
                                                                                Size(1500, 50), // button width and height
                                                                                child:
                                                                                ClipRect(
                                                                                  child: Material(
                                                                                    color: Colors.blue,
                                                                                    borderOnForeground: true, // button color
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          "Edit Barang",
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                                                                                        ), // text
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              TextFormField(
                                                                                textCapitalization:
                                                                                TextCapitalization.words,
                                                                                decoration:
                                                                                InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                  labelText: 'Nama Barang',
                                                                                ),
                                                                                enabled:
                                                                                gantiNama,
                                                                                controller:
                                                                                controllerNama,
                                                                                validator:
                                                                                    (controllerNama) {

                                                                                  update(index, controllerNama);
                                                                                  print('GN ' + gantiNama.toString());
                                                                                  print('adadas' + hasil.toString());
                                                                                  if (controllerNama == null || controllerNama.isEmpty) {
                                                                                    return 'Masukan Nama Barang Baru';
                                                                                  } else if (hasil == true) {
                                                                                    return outputValidasi;
                                                                                  } else {
                                                                                    return null;
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                            StreamBuilder<
                                                                                QuerySnapshot>(
                                                                                stream:
                                                                                Firestore.instance.collection('kategori').snapshots(),
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
                                                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                        child: DropdownButtonFormField(
                                                                                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Kategori Barang'),
                                                                                          value: katBarang,
                                                                                          items: kategoriItems,
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Kategori Barang Wajib Diisi';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          onChanged: (kategoriValue) {
                                                                                            setState(() {
                                                                                              selectedKategoriEdit = kategoriValue;
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                }),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              TextFormField(
                                                                                  decoration:
                                                                                  InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    labelText: 'Harga Jual Barang',
                                                                                  ),
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  inputFormatters: [
                                                                                    CurrencyTextInputFormatter(locale: 'id', decimalDigits: 0, symbol: 'Rp')
                                                                                  ],
                                                                                  controller: controllerHj,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Harga Jual Wajib Diisi';
                                                                                    }
                                                                                    return null;
                                                                                  }),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              TextFormField(
                                                                                  decoration: InputDecoration(
                                                                                      border:
                                                                                      OutlineInputBorder(),
                                                                                      labelText:
                                                                                      'Harga Beli Barang'),
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  inputFormatters: [
                                                                                    CurrencyTextInputFormatter(locale: 'id', decimalDigits: 0, symbol: 'Rp')
                                                                                  ],
                                                                                  controller: controllerHb,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Harga Beli Wajib Diisi';
                                                                                    }
                                                                                    return null;
                                                                                  }),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child: TextFormField(
                                                                                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Jumlah Stok'),
                                                                                  keyboardType: TextInputType.number,
                                                                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                                                  controller: controllerjmlStok,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Jumlah Stok Wajib Diisi';
                                                                                    }
                                                                                    return null;
                                                                                  }),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child: TextFormField(
                                                                                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Minimum Stok'),
                                                                                keyboardType: TextInputType.number,
                                                                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                                                controller: controllerminStok,
                                                                              ),
                                                                            ),
                                                                            StreamBuilder<
                                                                                QuerySnapshot>(
                                                                                stream:
                                                                                Firestore.instance.collection('supplier').snapshots(),
                                                                                builder: (context, snapshot) {
                                                                                  if (!snapshot.hasData) {
                                                                                    return Text("Tidak bisa mendapatkan data");
                                                                                  } else {
                                                                                    List<DropdownMenuItem> supplierItems = [];
                                                                                    for (int i = 0; i < snapshot.data.documents.length; i++) {
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
                                                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                        child: DropdownButtonFormField(
                                                                                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Supplier Barang'),
                                                                                          value: namaSupplier,
                                                                                          items: supplierItems,
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Supplier Barang Wajib Diisi';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          onChanged: (supplierValue) {
                                                                                            setState(() {
                                                                                              selectedSupplierEdit = supplierValue;
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                }),
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                              children: <
                                                                                  Widget>[
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                  // ignore: deprecated_member_use
                                                                                  child: RaisedButton(
                                                                                    onPressed: () async {
                                                                                      if (_formKey.currentState.validate()) {
                                                                                        Navigator.of(konteksUpdate).pop();
                                                                                      }
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
                                                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                                                                                          "Apakah benar anda ingin menghapus barang" + ' ' + controllerNama.text + "?",
                                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Row(
                                                                                                        mainAxisAlignment : MainAxisAlignment.end,
                                                                                                          children: <Widget>[
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                          child: SizedBox(
                                                                                                            height: 50,
                                                                                                            width: 180,
                                                                                                            // ignore: deprecated_member_use
                                                                                                            child: RaisedButton(
                                                                                                              color: Colors.red,
                                                                                                              child: Text(
                                                                                                                "Hapus",
                                                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                                                                                                              ),
                                                                                                              onPressed: () {
                                                                                                                Navigator.of(konteksUpdate).pop();
                                                                                                                deleteBarang(index, deleteKonteks);
                                                                                                              },
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                          child: SizedBox(
                                                                                                            height: 50,
                                                                                                            width: 180,
                                                                                                            // ignore: deprecated_member_use
                                                                                                            child: RaisedButton(
                                                                                                              child: Text("Batal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                                                                                                              onPressed: () {
                                                                                                                Navigator.of(deleteKonteks).pop();
                                                                                                                Navigator.of(konteksUpdate).pop();
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
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 180,
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
                                                      gantiNama = false;
                                                      Navigator.of(editKonteks)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          konteksUpdate) {
                                                            return AlertDialog(
                                                              content: Stack(
                                                                // ignore: deprecated_member_use
                                                                overflow: Overflow
                                                                    .visible,
                                                                children: <Widget>[
                                                                  SingleChildScrollView(
                                                                    child: Form(
                                                                      key: _formKey,
                                                                      child:
                                                                      Container(
                                                                        child:
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              SizedBox.fromSize(
                                                                                size:
                                                                                Size(1500, 50), // button width and height
                                                                                child:
                                                                                ClipRect(
                                                                                  child: Material(
                                                                                    color: Colors.blue,
                                                                                    borderOnForeground: true, // button color
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          "Edit Barang",
                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                                                                                        ), // text
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              TextFormField(
                                                                                textCapitalization:
                                                                                TextCapitalization.words,
                                                                                decoration:
                                                                                InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                  labelText: 'Nama Barang',
                                                                                ),
                                                                                enabled:
                                                                                gantiNama,
                                                                                controller:
                                                                                controllerNama,
                                                                              ),
                                                                            ),
                                                                            StreamBuilder<
                                                                                QuerySnapshot>(
                                                                                stream:
                                                                                Firestore.instance.collection('kategori').snapshots(),
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
                                                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                        child: DropdownButtonFormField(
                                                                                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Kategori Barang'),
                                                                                          value: katBarang,
                                                                                          items: kategoriItems,
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Kategori Barang Wajib Diisi';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          onChanged: (kategoriValue) {
                                                                                            setState(() {
                                                                                              selectedKategoriEdit = kategoriValue;
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                }),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              TextFormField(
                                                                                  decoration:
                                                                                  InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    labelText: 'Harga Jual Barang',
                                                                                  ),
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  inputFormatters: [
                                                                                    CurrencyTextInputFormatter(locale: 'id', decimalDigits: 0, symbol: 'Rp')
                                                                                  ],
                                                                                  controller: controllerHj,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Harga Jual Wajib Diisi';
                                                                                    }
                                                                                    return null;
                                                                                  }),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child:
                                                                              TextFormField(
                                                                                  decoration: InputDecoration(
                                                                                      border:
                                                                                      OutlineInputBorder(),
                                                                                      labelText:
                                                                                      'Harga Beli Barang'),
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  inputFormatters: [
                                                                                    CurrencyTextInputFormatter(locale: 'id', decimalDigits: 0, symbol: 'Rp')
                                                                                  ],
                                                                                  controller: controllerHb,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Harga Beli Wajib Diisi';
                                                                                    }
                                                                                    return null;
                                                                                  }),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child: TextFormField(
                                                                                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Jumlah Stok'),
                                                                                  keyboardType: TextInputType.number,
                                                                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                                                  controller: controllerjmlStok,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Jumlah Stok Wajib Diisi';
                                                                                    }
                                                                                    return null;
                                                                                  }),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  vertical: 10,
                                                                                  horizontal: 10),
                                                                              child: TextFormField(
                                                                                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Minimum Stok'),
                                                                                keyboardType: TextInputType.number,
                                                                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                                                controller: controllerminStok,
                                                                              ),
                                                                            ),
                                                                            StreamBuilder<
                                                                                QuerySnapshot>(
                                                                                stream:
                                                                                Firestore.instance.collection('supplier').snapshots(),
                                                                                builder: (context, snapshot) {
                                                                                  if (!snapshot.hasData) {
                                                                                    return Text("Tidak bisa mendapatkan data");
                                                                                  } else {
                                                                                    List<DropdownMenuItem> supplierItems = [];
                                                                                    for (int i = 0; i < snapshot.data.documents.length; i++) {
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
                                                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                        child: DropdownButtonFormField(
                                                                                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Supplier Barang'),
                                                                                          value: namaSupplier,
                                                                                          items: supplierItems,
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Supplier Barang Wajib Diisi';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          onChanged: (supplierValue) {
                                                                                            setState(() {
                                                                                              selectedSupplierEdit = supplierValue;
                                                                                            });
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                }),
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                              children: <
                                                                                  Widget>[
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                  // ignore: deprecated_member_use
                                                                                  child: RaisedButton(
                                                                                    onPressed: () async {
                                                                                      if (_formKey.currentState.validate()) {
                                                                                        Navigator.of(konteksUpdate).pop();
                                                                                      }
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
                                                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                                                                                          "Apakah benar anda ingin menghapus barang" + ' ' + controllerNama.text + "?",
                                                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Row(
                                                                                                          mainAxisAlignment : MainAxisAlignment.end,
                                                                                                          children: <Widget>[

                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                          child: SizedBox(
                                                                                                            height: 50,
                                                                                                            width: 180,
                                                                                                            // ignore: deprecated_member_use
                                                                                                            child: RaisedButton(
                                                                                                              color: Colors.red,
                                                                                                              child: Text(
                                                                                                                "Hapus",
                                                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                                                                                                              ),
                                                                                                              onPressed: () {
                                                                                                                Navigator.of(konteksUpdate).pop();
                                                                                                                deleteBarang(index, deleteKonteks);
                                                                                                              },
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                          child: SizedBox(
                                                                                                            height: 50,
                                                                                                            width: 180,
                                                                                                            // ignore: deprecated_member_use
                                                                                                            child: RaisedButton(
                                                                                                              child: Text("Batal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                                                                                                              onPressed: () {
                                                                                                                Navigator.of(deleteKonteks).pop();
                                                                                                                Navigator.of(konteksUpdate).pop();
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
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
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
                                            child: RaisedButton(
                                              color: Colors.red,
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.of(editKonteks)
                                                    .pop();
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
                  leading: Icon(Icons.format_list_bulleted),
                  title: Text(
                    namaBarang,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    hjBarang,
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    'Stok : ' + jmlStok,
                    style: TextStyle(fontSize: 20),
                  ),
                )),
          ),
        );
      },
    );
  }

  void setState(Null Function() param0) {}
}
