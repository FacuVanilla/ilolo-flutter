import 'package:flutter/material.dart';

class AppBarWithSearch extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithSearch({required this.onSearchChanged, this.focus = false, this.data = '', super.key});
  final ValueChanged<String> onSearchChanged;
  final bool focus;
  final String data;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      title: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: TextField(
            autofocus: focus,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search $data...',
              hintStyle: const TextStyle(color: Colors.white),
              contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
              border: InputBorder.none,
              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              suffixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            onChanged: onSearchChanged,
            // onSubmitted: onSearchChanged,
          ),
        ),
      ),
    );
  }
}
