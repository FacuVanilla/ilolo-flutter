import 'package:flutter/material.dart';
import 'package:ilolo/utils/style.dart';

class CustomText extends StatelessWidget {
  final double height1;
  final double height2;
  final String text1;
  final String text2;

  const CustomText(
      {super.key,
      required this.text1,
      required this.text2,
      required this.height1,
      required this.height2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text1,
          style: headStyle1,
        ),
        // Gap(height1),
        const Divider(
          thickness: 2,
        ),
        // Gap(height2),
        Text(
          text2,
          style: headStyle2,
        )
      ],
    );
  }
}
