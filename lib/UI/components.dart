import 'package:flutter/material.dart';

List<Color> colors = [
  const Color(0xff0048BA),
  const Color(0xffB0BF1A),
  const Color(0xff72A0C1),
  const Color(0xffDB2D43),
  const Color(0xffC46210),
  const Color(0xffD3212D),
  const Color(0xff3B7A57),
  const Color(0xff665D1E),
  const Color(0xff008000),
  const Color(0xff4B5320),
  const Color(0xff007FFF),
  const Color(0xff848482),
  const Color(0xff967117),
  const Color(0xff000000),
  const Color(0xff660000),
  const Color(0xff064E40),
  const Color(0xff126180),
  const Color(0xff66FF00),
];

textField({
  required String title,
  required String msg,
  TextEditingController? controller,
  required Color color,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      cursorColor: color,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return msg;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(fontSize: 15, color: color),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        contentPadding: const EdgeInsets.only(left: 10),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: .5),
        ),
      ),
    );
