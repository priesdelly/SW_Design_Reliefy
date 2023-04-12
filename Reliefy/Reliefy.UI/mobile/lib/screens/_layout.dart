import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import '../components/bottom_navigator.dart';
import '../controllers/fireauth_controller.dart';
import 'appointment_screen.dart';
import 'home_screen.dart';
import 'menu_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final FireAuthController authController = Get.find();

  int currentPageIndex = 0;
  static List<LayoutPage> layoutPages = [
    LayoutPage("Appointment", const AppointmentScreen()),
    LayoutPage("Home", const HomeScreen()),
    LayoutPage("Menu", MenuScreen()),
  ];

  void _onTap(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(layoutPages.elementAt(currentPageIndex).name),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        leadingWidth: 0,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: layoutPages.elementAt(currentPageIndex).widget,
      bottomNavigationBar: BottomNavigator(
        currentPageIndex: currentPageIndex,
        onCurrentPageChange: _onTap,
      ),
    );
  }
}

class LayoutPage {
  String name;
  Widget widget;

  LayoutPage(this.name, this.widget);
}
