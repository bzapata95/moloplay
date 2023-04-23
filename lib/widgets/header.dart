import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String? titleButton;
  final Function()? onPressTitleButton;

  const Header({
    super.key,
    required this.title,
    this.titleButton,
    this.onPressTitleButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
        if (titleButton != null)
          Text(titleButton!,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white.withOpacity(0.7)))
      ],
    );
  }
}
