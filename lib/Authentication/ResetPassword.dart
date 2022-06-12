import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/CustomWidgets/CustomFormButton.dart';
import 'package:todo/CustomWidgets/CustomFormTextField.dart';
import 'package:todo/CustomWidgets/CustomToast.dart';
import 'package:todo/NavigationPage.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailEditingController = TextEditingController();

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
                'Reset Password',
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
              SizedBox(height: 40.h),
              CustomFormButton(
                onTap: () {
                  if (_emailEditingController.text.isEmpty) {
                    toast(context, 'all fields required');
                  } else {
                    try {
                      resetPassword(_emailEditingController.text);
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                      toast(context, e.toString());
                    }
                  }
                },
                title: 'Send Request',
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                behavior: HitTestBehavior.translucent,
                child: Text(
                  "No, thanks!",
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
        ),
      ),
    );
  }

  resetPassword(String email) {
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
  }
}
