import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({required this.onPressed, required this.icon, super.key});
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color here 203 213 225
        borderRadius: BorderRadius.circular(50.0), // Optional: Rounded corners
      ),
      child: IconButton(
        color: Theme.of(context).primaryColor,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }
}
