import 'package:get/route_manager.dart';
import 'package:mobile/screens/_layout.dart';
import 'package:mobile/screens/create_appointment_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import '../screens/register.screen.dart';

class PageRoutes {
  static const String home = "/home";
  static const String login = "/login";
  static const String register = "/register";
  static const String createAppointment = "/createAppointment";
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
  GetPage(
    name: PageRoutes.createAppointment,
    page: () => const CreateAppointmentScreen(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
];
