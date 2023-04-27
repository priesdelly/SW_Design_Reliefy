import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/utils/constant.dart';

// ignore: must_be_immutable
class Accordion extends StatefulWidget {
  final String title;
  final Widget content;
  bool showContent = false;

  Accordion({Key? key, required this.title, required this.content, required this.showContent}) : super(key: key);
  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            setState(() {
              widget.showContent = !widget.showContent;
            });
          },
          child: ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 20, color: kSecondaryColor),
            ),
            trailing: FaIcon(widget.showContent ? FontAwesomeIcons.chevronUp : FontAwesomeIcons.chevronDown,
                color: kSecondaryColor),
          ),
        ),
        widget.showContent
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: widget.content,
              )
            : Container()
      ]),
    );
  }
}
