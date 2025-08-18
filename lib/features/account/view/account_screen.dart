import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/account/repository/user_advert_repository.dart';
import 'package:ilolo/features/account/view/delete_account_screen.dart';
import 'package:ilolo/features/auth/repository/login_repository.dart';
import 'package:ilolo/features/auth/repository/logout_repository.dart';
import 'package:ilolo/features/subscription/repository/subscription_repository.dart';
import 'package:ilolo/widgets/app_bar/profile_app_bar_widget.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserAdvertRepository>().getActiveAdverts();
    context.read<UserAdvertRepository>().getReviewAdverts();
    context.read<UserAdvertRepository>().getClosedAdverts();
    context.read<SubscriptionRepository>().getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final logoutButtonState = context.watch<LogoutRepository>().loader;
    return Scaffold(
      appBar: const ProfileAppBarWidget(),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () => context.push('/profile-view'),
              leading: const Icon(Boxicons.bx_user),
              title: const Text("Profile"),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
            ),
          ),
          // ********************************************************************************
          // ********************************************************************************
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () => context.push('/my-adverts'),
              leading: const Icon(Boxicons.bx_bar_chart_alt_2),
              title: const Text("My adverts"),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
            ),
          ),
          // ********************************************************************************
          // ********************************************************************************
          Platform.isIOS == true
              ? context.read<LoginRepository>().googleStatus == true
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: ListTile(
                        tileColor: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onTap: () => context.push('/boost-ads'),
                        leading: const Icon(Boxicons.bxl_bootstrap),
                        title: const Text("Boost Ads"),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                      ),
                    )
                  : const SizedBox()
              : Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: ListTile(
                    tileColor: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    onTap: () => context.push('/boost-ads'),
                    leading: const Icon(Boxicons.bxl_bootstrap),
                    title: const Text("Boost Ads"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    ),
                  ),
                ),
          // ********************************************************************************
          // ********************************************************************************
          Platform.isIOS == true
              ? context.read<LoginRepository>().googleStatus == true
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: ListTile(
                        tileColor: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onTap: () => context.push('/subscription'),
                        leading: const Icon(Boxicons.bx_credit_card),
                        title: const Text("Subscription"),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                      ),
                    )
                  : const SizedBox()
              : Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: ListTile(
                    tileColor: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    onTap: () => context.push('/subscription'),
                    leading: const Icon(Boxicons.bx_credit_card),
                    title: const Text("Subscription"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    ),
                  ),
                ),
          // ********************************************************************************
          // ********************************************************************************
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () async {
                final LogoutRepository logout = context.read<LogoutRepository>();
                logout.setLoader();
                await logout.attempt(context);
                logout.setIdle();
              },
              leading: const Icon(Boxicons.bx_log_out),
              title: const Text("Logout"),
              trailing: logoutButtonState == LoadState.loading
                  ? CupertinoActivityIndicator(
                      radius: 16.0,
                      color: Theme.of(context).primaryColor,
                    )
                  : const SizedBox(),
            ),
          ),
          // ********************************************************************************
          // ********************************************************************************
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: ListTile(
              tileColor: Colors.red[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccountScreen()));
              },
              leading: const Icon(Boxicons.bx_trash_alt, color: Colors.red),
              title: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
