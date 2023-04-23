import 'package:flutter/material.dart';

enum enumColorButton { white, black }

class Button extends StatelessWidget {
  final Function() onPressed;
  final String label;
  final enumColorButton colorButton;

  const Button({
    super.key,
    required this.onPressed,
    required this.label,
    this.colorButton = enumColorButton.black,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 0,
            backgroundColor: colorButton == enumColorButton.black
                ? Colors.black
                : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20)),
        child: Text(
          label,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: colorButton == enumColorButton.black
                  ? Colors.white
                  : Colors.black),
        ),
      ),
    );
  }
}
