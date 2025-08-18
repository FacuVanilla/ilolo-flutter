import 'package:flutter/material.dart';

class PricingAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const PricingAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0);

  @override
  State<PricingAppBarWidget> createState() => _PricingAppBarWidgetState();
}

class _PricingAppBarWidgetState extends State<PricingAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text("Advert pricing"),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }
}