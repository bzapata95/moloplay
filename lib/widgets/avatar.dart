import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final double radius;
  final String? name;

  const Avatar({
    super.key,
    this.size = 50,
    this.radius = 15,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: Colors.primaries[name!.length <= 17 ? name!.length : 17]),
      child: Center(
          child: Text(
        name != null ? name!.substring(0, 1) : "U",
        style: TextStyle(fontSize: size / 2.5, fontWeight: FontWeight.bold),
      )),
    );
  }
}
