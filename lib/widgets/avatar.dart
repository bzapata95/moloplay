import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final double radius;
  final String name;
  final String? urlImage;

  const Avatar({
    super.key,
    this.size = 50,
    this.radius = 15,
    required this.name,
    this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: Colors.black),
      child: urlImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.network(
                urlImage!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            )
          : Center(
              child: Text(
              name != null ? name!.substring(0, 1) : "U",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: size / 2.5,
                  fontWeight: FontWeight.bold),
            )),
    );
  }
}
