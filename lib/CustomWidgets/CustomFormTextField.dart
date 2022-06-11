import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormTextField extends StatefulWidget {
  final TextEditingController controller;
  final String lableText;
  final String hintText;
  final bool isPassword;
  const CustomFormTextField({
    Key? key,
    required this.controller,
    this.lableText = '',
    this.hintText = '',
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  late bool obscureText;
  @override
  void initState() {
    obscureText = widget.isPassword;
    obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.lableText,
          style: GoogleFonts.roboto(
            fontSize: 21.sp,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 60.h,
          width: 300.w,
          child: TextField(
            controller: widget.controller,
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
            cursorColor: Colors.blueGrey,
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: Visibility(
                visible: widget.isPassword,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 25.sp,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              hintText: widget.hintText,
              hintStyle: GoogleFonts.roboto(
                fontSize: 18.sp,
                color: Colors.blueGrey[300],
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.sp,
                  color: Colors.blueGrey.shade700,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.sp,
                  color: Colors.blueGrey,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
