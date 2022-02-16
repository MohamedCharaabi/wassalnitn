import 'package:wassalni/views/screens/auth/reset_password_screen.dart';
import 'package:wassalni/views/screens/auth/signin_screen.dart';
import 'package:wassalni/views/screens/auth/signup_screen.dart';
import 'package:wassalni/views/screens/home/home_screen.dart';

final routes = {
  '/signin': (context) => const SigninScreen(),
  '/signup': (context) => const SignupScreen(),
  '/reset_pass': (context) => const ResetPasswordScreen(),
  '/home': (context) => const HomeScreen(),
};
