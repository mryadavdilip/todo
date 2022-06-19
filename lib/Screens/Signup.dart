import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/Authentication/auth_controller.dart';
import 'package:todo/CustomWidgets/CustomFormButton.dart';
import 'package:todo/CustomWidgets/CustomFormTextField.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  TextEditingController _confPasswordEditingController =
      TextEditingController();

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _confPasswordEditingController.dispose();
    super.dispose();
  }

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
                'Sign Up',
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
              SizedBox(height: 30.h),
              CustomFormTextField(
                isPassword: true,
                controller: _confPasswordEditingController,
                lableText: 'Confirm Password',
                hintText: 'Confirm Password',
              ),
              SizedBox(height: 40.h),
              CustomFormButton(
                onTap: () {
                  AuthConroller(context: context).signupWithEmailAndPassword(
                      _emailEditingController.text,
                      _passwordEditingController.text,
                      _confPasswordEditingController.text);
                },
                title: 'Sign up',
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
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
                      Navigator.pop(context);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      "Login here",
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
}
