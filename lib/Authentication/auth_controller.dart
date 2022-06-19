import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/CustomWidgets/CustomToast.dart';
import 'package:flutter/material.dart';
import 'package:todo/NavigationPage.dart';

class AuthConroller {
  final BuildContext context;
  AuthConroller({
    required this.context,
  });
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  loginWithEmaiAndPassword(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      toast(context, 'all fields required');
    } else {
      try {
        _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((credential) {
          _firestore.collection('users').doc(email).update({
            'lastLogin':
                "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}, ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}"
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationPage(),
              ),
              (route) => false);
        }).onError((error, stackTrace) {
          toast(context, error.toString());
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        toast(context, e.toString());
      }
    }
  }

  signupWithEmailAndPassword(
    String email,
    String password,
    String confirmPassword,
  ) {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      toast(context, 'all fields required');
    } else if (password != confirmPassword) {
      toast(context, "password does'nt match");
    } else {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((credential) {
        _firestore.collection('users').doc(credential.user!.email).set({
          'email': credential.user!.email,
        });
        toast(context, 'account created successfully');
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        toast(context, error.toString());
        if (kDebugMode) {
          print(error);
        }
      });
    }
  }

  signInWithGoogle() {
    GoogleSignIn()
        .signIn()
        .then((value) => toast(context, 'Signed in successfully'))
        .catchError(
          (e) => toast(
            context,
            e.toString(),
          ),
        );
  }

  resetPassword(String email) {
    if (email.isEmpty) {
      toast(context, 'all fields required');
    } else {
      try {
        _auth.sendPasswordResetEmail(email: email).then((credential) {
          _firestore.collection('users').doc(email).update({
            'lastResetRequest':
                "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}, ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}"
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationPage(),
              ),
              (route) => false);
          toast(context, 'reset request sent to your email');
        }).onError((error, stackTrace) {
          toast(context, error.toString());
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        toast(context, e.toString());
      }
    }
  }

  signout() {
    _auth.signOut().then(
      (v) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationPage(),
            ),
            (route) => false);
        toast(context, 'logged out successfully');
      },
    ).onError(
      (error, stackTrace) {
        toast(
          context,
          error.toString(),
        );
      },
    );
  }
}
