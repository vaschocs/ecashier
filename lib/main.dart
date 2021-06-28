
import 'package:ecashier/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Login',
      theme:  ThemeData(
        primaryColor: Colors.white
      ),

      home : MyLogin(),
    );

  }
}

class MyLogin extends StatefulWidget{
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
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );

    FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return SplashScreenPage();
        }
        )
    );
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
              new Image.asset("assets/images/logo.png", width: 500,),

              new InkWell(
                onTap: () {
print(info);
               doLogin();
                },
                child: new Image.asset("assets/images/signin.png", width: 400,),



              )


            ],),

        ),
      );
    }

}