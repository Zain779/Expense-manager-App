import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.myController,
    required this.onValidator,
    required this.obsecureText,
    required this.hint,
  }) : super(key: key);
  final TextEditingController myController;
  final FormFieldValidator onValidator;
  final bool obsecureText;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      validator: onValidator,
      obscureText: obsecureText,
      decoration: InputDecoration(
        hintText: hint,
        // fillColor: const Color(0xffF8F9FA),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffE4E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffE4E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
