import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key? key,
    this.hintText,
    this.validator,
    this.inputType = TextInputType.text,
    required this.controller,
    this.readonly = false,
  }) : super(key: key);
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final TextEditingController controller;
  final bool readonly;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 1,
            // color: Palette.kMainTheme.shade500,
          )),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          errorStyle: const TextStyle(height: 0),
        ),
        validator: validator,
        enableSuggestions: false,
        autocorrect: false,
        obscureText: true,
        obscuringCharacter: '•',
        readOnly: readonly,
      ),
    );
  }
}
