import 'package:healthroom_app/screen/home_screen.dart';
import 'package:healthroom_app/screen/auth/login_screen.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
};
