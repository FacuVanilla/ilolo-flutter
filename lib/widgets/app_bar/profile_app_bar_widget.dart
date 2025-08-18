import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const ProfileAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0);

  @override
  State<ProfileAppBarWidget> createState() => _ProfileAppBarWidgetState();
}

class _ProfileAppBarWidgetState extends State<ProfileAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 25,
          ),
          onPressed: (){
            // context.push('/change-password');
          },
        ),
        const Gap(5),
      ],
      title: const Text("Account"),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }
}
