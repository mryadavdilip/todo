import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/Screens/Login.dart';
import 'package:todo/CustomWidgets/CustomToast.dart';
import 'package:todo/Screens/HomePage/HomePage.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('_auth: ${_auth.currentUser}');
    }
    return FutureBuilder(
        future: GoogleSignIn().isSignedIn(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _auth.currentUser != null && snapshot.data
                ? HomePage()
                : LoginPage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            toast(context, 'something went wrong!');
            return Center();
          }
        });
  }
}
