import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecashier/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(primaryColor: Colors.white),
      home: MyLogin(),
    );
  }
}

// ignore: deprecated_member_use
List<Map> transaksiItem = new List<Map>();

Future getData() async {
  // ignore: await_only_futures
  await Firestore.instance
      .collection('barang')
      .snapshots()
      .listen((documents) {
    transaksiItem.clear();
    if (documents.documents.length != 0) {
      documents.documents.forEach((d) {
        Map document = new Map();
        document['docDate']=d['docDate'];
        document['hbBarang'] = d['hbBarang'];
        document['hjBarang'] = d['hjBarang'];
        document['jmlStok'] = d['jmlStok'];
        document['kategoriBarang'] = d['kategoriBarang'];
        document['kategoriPergerakan'] = d['kategoriPergerakan'];
        document['minStok'] = d['minStok'];
        document['namaBarang'] = d['namaBarang'];
        document['namaSupplier'] = d['namaSupplier'];
        document['rataPenjualan'] = d['rataPenjualan'];
        document['rataPenjualanTinggi'] = d['rataPenjualanTinggi'];
        document['stokAwal']=d['stokAwal'];
        document['stokPakai']=d['stokPakai'];
        document['tanggalPergerakan']=d['tanggalPergerakan'];
        document['waktu']=d['waktu'];
        document['waktuPesan']=d['waktuPesan'];
        document['waktuPesanLama']=d['waktuPesanLama'];
        transaksiItem.add(document);
      });
    }
  });
}



class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => new _MyLoginState();
}

String info = "";

class _MyLoginState extends State<MyLogin> {
  final FirebaseAuth firebaseauth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  void doLogin() {
    _signIn().then((FirebaseUser user) {
      // setState(() {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (_) {
      //       return SplashScreenPage();
      //     }),
      //   );
      // });
      setState(() {
        info = "${user.displayName}";
      });
    }).catchError((e) => print(e.toString()));
  }

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return SplashScreenPage();
    }));
    return user;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            new Image.asset(
              "assets/images/logo.png",
              width: 500,
            ),
            new InkWell(
              onTap: () {
                doLogin();
                getData();
              },
              child: new Image.asset(
                "assets/images/signin.png",
                width: 400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
