import 'package:flutter/material.dart';

class MessageAppBarWidget extends StatefulWidget implements PreferredSizeWidget{
  const MessageAppBarWidget({required this.title, super.key});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0);

  @override
  State<MessageAppBarWidget> createState() => _MessageAppBarWidgetState();
}

class _MessageAppBarWidgetState extends State<MessageAppBarWidget> {
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