import 'package:wassalni/views/client/home/home_screen.dart';
import 'package:wassalni/views/client/home/request_ride.dart';
import 'package:wassalni/views/rider/driver_main_screen.dart';
import 'package:wassalni/views/screens/auth/reset_password_screen.dart';
import 'package:wassalni/views/screens/auth/signin_screen.dart';
import 'package:wassalni/views/screens/auth/signup_screen.dart';
// import 'package:wassalni/views/screens/home/home_screen.dart';

final routes = {
  '/signin': (context) => SigninScreen(),
  '/signup': (context) => const SignupScreen(),
  '/reset_pass': (context) => const ResetPasswordScreen(),
  // client
  '/home': (context) => const HomeScreen(),
  'request_ride': (context) => const RequestRideScreen(),

  // driver
  '/driver_': (context) => const DriverMainScreen(),
};
