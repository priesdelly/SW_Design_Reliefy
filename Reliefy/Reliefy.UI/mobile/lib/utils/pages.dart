import 'package:get/route_manager.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';

class Page {
  static const String home = "/";
  static const String login = "/login";
}

final pages = [
  GetPage(
    name: Page.home,
    page: () => HomeScreen(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: Page.login,
    page: () => const LoginScreen(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];
