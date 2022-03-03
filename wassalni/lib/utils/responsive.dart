import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  BuildContext context;

  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  double getHeight(double percent) => height * percent;
  double getWidth(double percent) => width * percent;

  double getStatusBarHeight() => MediaQuery.of(context).viewPadding.top;

  bool isPortrait() =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  bool isExtraSmall() => width < 400;
  bool isSmallScreen() => width < 600;
  bool isMediumScreen() => width < 900; // tablet
  bool isLargeScreen() => width < 1200;
  bool isExtraLargeScreen() => width < 1800;

  double getResponsiveHeight(double h) => ScreenUtil().setHeight(h);
  double getResponsiveWidth(double w) => ScreenUtil().setWidth(w);
}
