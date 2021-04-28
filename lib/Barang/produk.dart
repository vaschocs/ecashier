import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecashier/Barang/addBarang.dart';
import 'package:ecashier/Barang/editBarang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
      stream: Firestore.instance.collection('barang').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return new Container(
              child: Center(
                child: CircularProgressIndicator(),
              ));
        return new TaskList(
          document: snapshot.data.documents,
        );
      },
    ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahBarangPage(),
              ));
        },
        label: Text('Tambah'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});

  final List<DocumentSnapshot> document;



  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (
          BuildContext context,
          int i,
          ) {
        String namaBarang = document[i].data['namaBarang'].toString();
        String hjBarang  = document[i].data['hjBarang'].toString();
        String minStok = document[i].data['minStok'].toString();
        String katBarang = document[i].data['kategoriBarang'].toString();
        String hbBarang = document[i].data['hbBarang'].toString();
        String jmlStok = document[i].data['jmlStok'].toString();
        String imgBarang = document[i].data['imgBarang'].toString();
        String satuan = document[i].data['satuan'].toString();

        TextEditingController editKategori;

        final index = document[i].reference;

        return new Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              color: Colors.white60,
              child: Card(
                shape: Border.all(color: Colors.green),
                child: ListTile(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context)=> new EditBarangPage(
                        namaBarang: namaBarang,
                        katBarang: katBarang,
                        hjBarang : hjBarang,
                        hbBarang : hbBarang,
                        jmlStok: jmlStok,
                        minStok: minStok,
                        satuan: satuan,
                        index : document[i].reference,
                      )
                    ));
                  },
                  leading: SizedBox(
                    height: 30.0,
                  width: 40.0,
                  child: Image(image: AssetImage (imgBarang)),),
                  title: Text(namaBarang, style: TextStyle(fontSize: 20),),
                subtitle: Text(hjBarang, style: TextStyle(fontSize: 18),),
                trailing: Text(jmlStok, style: TextStyle(fontSize: 20),),
                )

                ),
              ),
        );

      },
    );
  }
}
