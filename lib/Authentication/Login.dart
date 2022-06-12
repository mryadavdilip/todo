import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/Authentication/ResetPassword.dart';
import 'package:todo/Authentication/Signup.dart';
import 'package:todo/CustomWidgets/CustomFormButton.dart';
import 'package:todo/CustomWidgets/CustomFormTextField.dart';
import 'package:todo/CustomWidgets/CustomToast.dart';
import 'package:todo/NavigationPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: 812.h,
          width: 375.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: GoogleFonts.roboto(
                  fontSize: 26.sp,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 1.h,
                width: 300.w,
                color: Colors.blueGrey,
              ),
              SizedBox(height: 40.h),
              CustomFormTextField(
                controller: _emailEditingController,
                lableText: 'Email',
                hintText: 'Email',
              ),
              SizedBox(height: 30.h),
              CustomFormTextField(
                isPassword: true,
                controller: _passwordEditingController,
                lableText: 'Password',
                hintText: 'Password',
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                    ),
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: Text(
                  'Forgot password?',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              CustomFormButton(
                onTap: () {
                  if (_emailEditingController.text.isEmpty ||
                      _passwordEditingController.text.isEmpty) {
                    toast(context, 'all fields required');
                  } else {
                    try {
                      login(_emailEditingController.text,
                          _passwordEditingController.text);
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                      toast(context, e.toString());
                    }
                  }
                },
                title: 'Login',
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blueGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "Create one",
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  login(String email, String password) {
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
  }
}
