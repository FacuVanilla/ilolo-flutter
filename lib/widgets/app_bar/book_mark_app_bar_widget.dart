import 'package:flutter/material.dart';

class BookMarkAppBarkWidget extends StatefulWidget implements PreferredSizeWidget{
  const BookMarkAppBarkWidget({required this.title, super.key});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0);
  @override
  State<BookMarkAppBarkWidget> createState() => _BookMarkAppBarkWidgetState();
}

class _BookMarkAppBarkWidgetState extends State<BookMarkAppBarkWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(widget.title),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }
}
