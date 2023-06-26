import 'package:flutter/material.dart';

enum enumColorButton { white, black }

class Button extends StatelessWidget {
  final Function()? onPressed;
  final Widget? icon;
  final String label;
  final enumColorButton colorButton;

  const Button({
    super.key,
    required this.label,
    this.onPressed,
    this.colorButton = enumColorButton.black,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 0,
        backgroundColor:
            colorButton == enumColorButton.black ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Row(
              children: [
                Center(child: icon),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: colorButton == enumColorButton.black
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
