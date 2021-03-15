import 'package:ecashier/Barang/add_image.dart';
import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TambahBarangPage(),
    );
  }
}



class TambahBarangPage extends StatefulWidget {
  @override
  _TambahBarangPageState createState()=> _TambahBarangPageState();
}


class _TambahBarangPageState extends State<TambahBarangPage>{
  TextEditingController imageBarang = TextEditingController();
  String path = '';
  TextEditingController namaBarang = TextEditingController();
  TextEditingController merkBarang = TextEditingController();
  TextEditingController katBarang = TextEditingController();
  TextEditingController hjBarang = TextEditingController();
  TextEditingController hbBarang = TextEditingController();
  TextEditingController barcodeBarang = TextEditingController();
  TextEditingController jmlStok = TextEditingController();
  TextEditingController satuan = TextEditingController();
  TextEditingController minStok = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();



  void add(){
   Firestore.instance.collection("barang").document(barcodeBarang.text).setData({
     'Nama Barang' : namaBarang.text,
     'Merk Barang' : merkBarang.text,
     'Kategori Barang' : katBarang.text,
     'Harga Jual' : hjBarang.text,
     'Harga Beli' : hbBarang.text,
     'Barcode Barang' : barcodeBarang.text,
     'Jumlah Stok' : jmlStok.text,
     'Satuan' : satuan.text,
     'Minimal Stok' : minStok.text
   });



   namaBarang.text = '';
   merkBarang.text = '';
   katBarang.text = '';
   hjBarang.text = '';
   hbBarang.text = '';
   barcodeBarang.text = '';
   jmlStok.text = '';
   satuan.text = '';
   minStok.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Tambah Produk'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        key: formKey,
        child: Container(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //   child: SizedBox.fromSize(
              //     size: Size(130, 130), // button width and height
              //     child: ClipRect(
              //       child: Material(
              //         color: Colors.grey,
              //         borderOnForeground: true, // button color
              //         child: InkWell(
              //           splashColor: Colors.green, // splash color
              //           onTap: () {
              //             Navigator.pushReplacement(
              //                 context,
              //                 MaterialPageRoute (),
              //                 );
              //           },
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: <Widget>[
              //               Icon(Icons.add),
              //               Text(" "), // icon
              //
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //   child: Column(
              //     children: <Widget>[
              //       TextFormField(
              //         decoration: InputDecoration(
              //             border: OutlineInputBorder(), labelText: 'Foto Barang'),
              //         autofocus: true,
              //         controller: imageBarang,
              //       ),
              //       RaisedButton(
              //         onPressed: add,
              //         color: Colors.green,
              //         child: Padding(
              //           padding: EdgeInsets.symmetric(vertical: 10),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: <Widget>[
              //               Text(
              //                 'Upload',
              //                 style: TextStyle(
              //                   fontSize: 20,
              //                   fontWeight: FontWeight.w700,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ]
              //   )
              // ),
              //
              //
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //   child: Image.network(path, width: 300, height: 300,),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox.fromSize(
                  size: Size(400, 30), // button width and height
                  child: ClipRect(
                    child: Material(
                      color: Colors.green,
                      borderOnForeground: true, // button color
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Text("Produk", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white), ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nama Barang'),
                  autofocus: true,
                  controller: namaBarang,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Merk Barang'),
                  autofocus: true,
                  controller: merkBarang,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Kategori Barang'),
                  autofocus: true,
                  controller: katBarang,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Harga Jual Barang',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: hjBarang,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Harga Beli Barang'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: hbBarang,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Barcode Barang'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: barcodeBarang,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SizedBox.fromSize(
                  size: Size(400, 30), // button width and height
                  child: ClipRect(
                    child: Material(
                      color: Colors.green,
                      borderOnForeground: true, // button color
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Text("Stok", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white), ), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Jumlah Stok'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: jmlStok,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Satuan Unit'),

                  controller: satuan,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Minimum Stok'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: minStok,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: RaisedButton(
                  onPressed: () async {
                    add();
                    Navigator.pushReplacement(context, MaterialPageRoute ( builder: (context) => TambahGambarPage(),
                    ));
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
