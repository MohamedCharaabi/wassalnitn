import 'package:flutter/material.dart';

class Responsive {
  final BuildContext _context;

  Responsive({required context}) : _context = context;

  double get width => MediaQuery.of(_context).size.width;
  double get height => MediaQuery.of(_context).size.height;

  double getWidth(double percent) => width * percent;
  double getHeight(double percent) => height * percent;
}
