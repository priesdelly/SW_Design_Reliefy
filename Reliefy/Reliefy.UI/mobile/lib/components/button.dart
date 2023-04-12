import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, this.onPressed, this.label, this.backgroundColor, this.child, this.borderColor, this.height});

  final void Function()? onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor ?? Colors.transparent)
      ),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith((_) => Colors.transparent),
        ),
        onPressed: onPressed,
        child: child ?? Text(
          label ?? "",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
