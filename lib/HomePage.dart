import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/CustomWidgets/CustomToast.dart';
import 'package:todo/NavigationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MaterialButton(
          onPressed: () {
            _auth.signOut().then(
              (v) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationPage(),
                    ),
                    (route) => false);
              },
            ).onError(
              (error, stackTrace) {
                toast(
                  context,
                  error.toString(),
                );
              },
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
