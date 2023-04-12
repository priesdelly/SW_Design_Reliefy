import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({
    Key? key,
    required this.currentPageIndex,
    required this.onCurrentPageChange,
  }) : super(key: key);
  final int currentPageIndex;
  final ValueChanged<int> onCurrentPageChange;

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      iconSize: 24,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.house),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.clockRotateLeft),
          label: "History",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.bars),
          label: "Menu",
        ),
      ],
      currentIndex: widget.currentPageIndex,
      onTap: widget.onCurrentPageChange,
    );
  }
}
