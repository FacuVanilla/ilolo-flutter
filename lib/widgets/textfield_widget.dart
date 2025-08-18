import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  final String hintText1;
  final Icon? suffixIcon1;

  const CustomTextField2({
    super.key,
    this.suffixIcon1,
    required this.hintText1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: hintText1,
                suffixIcon: suffixIcon1,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ],
      ),
    );
  }
}
