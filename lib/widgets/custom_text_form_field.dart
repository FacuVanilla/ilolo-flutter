import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Icon? suffixIcon1;
  final IconButton? suffixIcon2;
  final Widget? prefix;
  final bool obscureText;
  final TextInputType inputType;
  final bool numberOnly;
  final bool readOnly;
  final double leftRightPadding;
  final VoidCallback? onTap;
   final ValueChanged<String>? submit;
  final int rows;

  const CustomTextFormField(
      {super.key,
      required this.hintText,
      this.controller,
      required this.validator,
      this.suffixIcon1,
      this.suffixIcon2,
      this.prefix,
      this.obscureText = false,
      this.numberOnly = false,
      this.readOnly = false,
      this.leftRightPadding = 20,
      this.inputType = TextInputType.text,
      this.onTap,
      this.submit,
      this.rows = 1,
      });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.leftRightPadding, right: widget.leftRightPadding),
      child: TextFormField(
        onFieldSubmitted: widget.submit,
        onTap: widget.onTap,
        maxLines: widget.rows,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.hintText,
            suffixIcon: widget.suffixIcon1 ?? widget.suffixIcon2,
            prefix: widget.prefix),
        readOnly: widget.readOnly,
        keyboardType: widget.inputType,
        inputFormatters: [widget.numberOnly ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.obscureText,
      ),
    );
  }
}
