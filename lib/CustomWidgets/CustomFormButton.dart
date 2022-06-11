import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormButton extends StatefulWidget {
  final String title;
  final GestureTapCallback onTap;
  const CustomFormButton({
    Key? key,
    this.title = '',
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomFormButton> createState() => _CustomFormButtonState();
}

class _CustomFormButtonState extends State<CustomFormButton> {
  double offsetDX = 5;
  double offsetDY = 5;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        splashColor: Colors.black,
        onTapDown: (d) {
          setState(() {
            offsetDX = 0;
            offsetDY = 0;
          });
        },
        onTapUp: (d) {
          setState(() {
            offsetDX = 5;
            offsetDY = 5;
          });
        },
        onTap: widget.onTap,
        child: Container(
          height: 50.h,
          width: 250.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey[400],
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4.r,
                offset: Offset(offsetDX.w, offsetDY.h),
              )
            ],
          ),
          child: Text(
            widget.title,
            style: GoogleFonts.roboto(
              fontSize: 26.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
