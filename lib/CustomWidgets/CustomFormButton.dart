import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormButton extends StatefulWidget {
  final GestureTapCallback onTap;
  final String title;
  final double height;
  final double width;
  final bool outlined;
  const CustomFormButton({
    Key? key,
    required this.onTap,
    this.title = '',
    this.height = 50,
    this.width = 250,
    this.outlined = false,
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
          height: widget.height.h,
          width: widget.width.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.outlined ? Colors.white : Colors.blueGrey[400],
            border: widget.outlined
                ? Border.all(
                    width: 3.sp,
                    color: Colors.blueGrey.shade400,
                  )
                : Border.all(
                    width: 0,
                    color: Colors.transparent,
                  ),
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
              color: widget.outlined ? Colors.blueGrey : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
