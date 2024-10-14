import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final double radius;
  final Color bgColor;
  final Color textColor;

  CancelButton({
    super.key,
    required this.callback,
    this.text = "Cancel",
    this.radius = 10.0,
    Color? bgColor,
    this.textColor = Colors.black,
  }) : bgColor = bgColor ?? Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 24),
      ),
    );
  }
}

Widget SaveButton({required VoidCallback callback}) {
  return CancelButton(
    callback: callback,
    text: "Save",
    textColor: Colors.white,
    bgColor: Colors.blue.shade700,
  );
}
