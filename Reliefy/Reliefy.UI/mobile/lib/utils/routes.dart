import 'package:get/route_manager.dart';
import 'package:mobile/screens/_layout.dart';
import 'package:mobile/screens/complete_info_screen.dart';
import 'package:mobile/screens/create_appointment_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/ratting_screen.dart';
import 'package:mobile/screens/two_fa_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/register.screen.dart';

class PageRoutes {
  static const String home = "/home";
  static const String login = "/login";
  static const String register = "/register";
  static const String createAppointment = "/createAppointment";
  static const String chat = "/chat";
  static const String twoFa = "/twoFa";
  static const String conpleteInfo = "/completeInfo";
  static const String ratting = "/ratting";
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
  GetPage(
    name: PageRoutes.chat,
    page: () => const ChatScreen(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: PageRoutes.twoFa,
    page: () => const TwoFaScreen(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: PageRoutes.conpleteInfo,
    page: () => const CompleteInfoScreen(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: PageRoutes.ratting,
    page: () => RattingScreen(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
];
