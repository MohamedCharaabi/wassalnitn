import 'package:wassalni/views/screens/auth/reset_password_screen.dart';
import 'package:wassalni/views/screens/auth/signin_screen.dart';
import 'package:wassalni/views/screens/auth/signup_screen.dart';
import 'package:wassalni/views/screens/home/home_screen.dart';
import 'package:wassalni/views/screens/home/map_stream.dart';
import 'package:wassalni/views/screens/home/test_fire.dart';

final routes = {
  '/signup': (context) => SigninScreen(),
  '/signin': (context) => const SignupScreen(),
  '/reset_pass': (context) => const ResetPasswordScreen(),
  '/home': (context) => const HomeScreen(),
  '/map': (context) => TestFire(),
};
