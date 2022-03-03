import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:wassalni/utils/styles.dart';

class RideButton extends StatelessWidget {
  RideButton({Key? key, required this.text, required this.goTo})
      : super(key: key);

  final String text;
  // VoidCallback onPressed;
  final String goTo;

  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive(context);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, goTo),
      child: Container(
          height: _responsive.getHeight(0.15),
          // width: _responsive.getWidth(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
            gradient: default_gradient(),
          ),
          child: Row(
            children: <Widget>[
              Transform.rotate(
                angle: math.pi / 4,
                child: Image.asset(
                  'assets/images/car.png',
                  height: _responsive.getResponsiveWidth(55),
                  width: _responsive.getResponsiveWidth(55),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: _responsive.isSmallScreen() ? text_normal : text_bold,
              )
            ],
          )),
    );
  }
}
