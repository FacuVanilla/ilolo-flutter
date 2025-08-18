import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Profile"),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: ()=> context.push('/profile-view/personal'),
              leading: const Icon(Icons.account_box_rounded),
              title: const Text("Personal profile"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15,),
            ),
          ),
          // ********************************************************************************
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: ()=> context.push('/profile-view/business'),
              leading: const Icon(Icons.business_center_rounded),
              title: const Text("Business details"),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15,),
            ),
          ),
        ],
      ),
    );
  }
}