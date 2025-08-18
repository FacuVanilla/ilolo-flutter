import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: const Text("Account Deletion"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(color: Colors.red[50], border: Border.all(color: Colors.red, width: 0.50), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Text.rich(
                    TextSpan(
                      text: 'Please be warned that account deletion is an ',
                      children: <TextSpan>[
                        TextSpan(
                          text: 'irreversible action. ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'All adverts, transactions, subscriptions and any other data stored on ilolo will be deleted after this action. '),
                      ],
                    ),
                  ),
                  const Gap(10),
                  CustomButton(
                    onTap: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            await context.read<ProfileRepository>().deleteAccount(context);
                            setState(() {
                              isLoading = false;
                            });
                          },
                    text: isLoading
                        ? CupertinoActivityIndicator(
                            radius: 14.0,
                            color: Theme.of(context).primaryColor,
                          )
                        : const Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.white),
                          ),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
