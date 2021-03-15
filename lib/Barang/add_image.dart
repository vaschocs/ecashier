import 'dart:io';

import 'package:ecashier/side_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';


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
      home: TambahGambarPage(),
    );
  }
}


class TambahGambarPage extends StatefulWidget {
  @override
  _TambahGambarPageState createState() => _TambahGambarPageState();
}

class _TambahGambarPageState extends State<TambahGambarPage> {
  TextEditingController imageBarang = TextEditingController();
  String path = '';

  void upload() async{
    File file = await FilePicker.getFile();
    StorageReference sr = await FirebaseStorage.instance.ref().child('images/${imageBarang.text}');
    await sr.putFile(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text('Tambah Gambar'),
          backgroundColor: Colors.green,
        ),
        body:SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
                  child: SizedBox.fromSize(
                    size: Size(300, 300), // button width and height
                    child: ClipRect(
                      child: Material(
                          color: Colors.grey,
                          borderOnForeground: true, // button color
                          child: Image.network(path, width: 300, height: 300,)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Gambar Barang'),
                    controller: imageBarang,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: RaisedButton(
                      onPressed: upload,
                      color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Upload',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
        )
    );
  }
}
