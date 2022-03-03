import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wassalni/utils/constants.dart';

TextStyle text_bold = TextStyle(
    color: white,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins');

TextStyle text_normal =
    TextStyle(color: white, fontSize: 16.sp, fontFamily: 'Poppins');

LinearGradient default_gradient({bool horizontal = false}) => LinearGradient(
      colors: [
        mainColor,
        mainColor.withOpacity(0.5),
        mainColor.withOpacity(0.01),
      ],
      // stops: const [0.8, .9],
      begin: horizontal ? Alignment.centerLeft : Alignment.topCenter,
      end: horizontal ? Alignment.centerRight : Alignment.bottomCenter,
    );

SizedBox verticalSpace(double height) {
  return SizedBox(
    height: ScreenUtil().setHeight(height),
  );
}

SizedBox horizontalSpace(double width) {
  return SizedBox(
    width: ScreenUtil().setWidth(width),
  );
}
