import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final String hint;
  final IconData iconData;
  final bool isPassword;
  final TextEditingController controller;
  const InputFieldWidget({
    super.key,
    required this.hint,
    required this.iconData,
    required this.isPassword,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    //take the size of the current screen and determine if it is wide or not
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > 600;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
        color: Colors.white,
        width: 2
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
          color: Color(0xff0000ff),
          width: 2
      ),
    );

    return SizedBox(
      width: isWideScreen? size.width * .5: size.width * .9,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        autocorrect: !isPassword,
        enableSuggestions: !isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(iconData),
          border: border,
          enabledBorder: border,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }
}
