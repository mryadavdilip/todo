import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/Authentication/auth_controller.dart';
import 'package:todo/CustomWidgets/CustomFormButton.dart';
import 'package:todo/CustomWidgets/CustomFormTextField.dart';
import 'package:todo/Screens/ResetPassword.dart';
import 'package:todo/Screens/Signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
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
                  AuthConroller(context: context).loginWithEmaiAndPassword(
                      _emailEditingController.text,
                      _passwordEditingController.text);
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
              SizedBox(height: 40.h),
              CustomFormButton(
                onTap: () {
                  AuthConroller(context: context).signInWithGoogle();
                },
                title: 'Sign in with Google',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
