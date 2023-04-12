import 'package:get/route_manager.dart';
import 'package:mobile/screens/_layout.dart';
import 'package:mobile/screens/login_screen.dart';
import '../screens/register.screen.dart';

class PageRoutes {
  static const String home = "/home";
  static const String login = "/login";
  static const String register = "/register";
}

final pages = [
  GetPage(
    name: PageRoutes.home,
    page: () => const LayoutScreen(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: PageRoutes.login,
    page: () => const LoginScreen(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: PageRoutes.register,
    page: () => const RegisterScreen(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];
