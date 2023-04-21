import 'package:flutter/material.dart';
import 'package:molopay/widgets/avatar.dart';

class CardTransaction extends StatelessWidget {
  const CardTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xff1B1B1B),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              const Avatar(),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Irving Angelo'),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    '16/04/23',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          Text('- S/ 100',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}
