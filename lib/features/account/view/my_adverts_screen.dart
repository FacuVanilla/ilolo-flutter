import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/account/model/user_advert_model.dart';
import 'package:ilolo/features/account/repository/user_advert_repository.dart';
import 'package:ilolo/features/account/view/update_advert_screen.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class MyAdvertScreen extends StatefulWidget {
  const MyAdvertScreen({super.key});

  @override
  State<MyAdvertScreen> createState() => _MyAdvertScreenState();
}

class _MyAdvertScreenState extends State<MyAdvertScreen> {
  int _selectedIndex = 0;

  void _onSegmentChanged(int? index) => setState(() => _selectedIndex = index!);
  List<Widget> advertSection = [const ActiveAdvertWidget(), const ReviewAdvertWidget(), const ClosedAdvertWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text("My Adverts"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity, // Full width
            child: CupertinoSlidingSegmentedControl(
              children: {
                0: Text('Active', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800)),
                1: Text('Review', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800)),
                2: Text('Closed', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800)),
              },
              groupValue: _selectedIndex,
              onValueChanged: _onSegmentChanged,
            ),
          ),
          Expanded(child: advertSection[_selectedIndex])
        ],
      ),
    );
  }
}

class ActiveAdvertWidget extends StatelessWidget {
  const ActiveAdvertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<UserAdvertModel> userAdverts = context.watch<UserAdvertRepository>().activeAdverts;
    return RefreshIndicator.adaptive(
      onRefresh: () async => context.read<UserAdvertRepository>().getActiveAdverts(),
      child: ListView(
        // shrinkWrap: true,
        children: userAdverts.isEmpty
            ? [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(65),
                      Icon(
                        Boxicons.bx_bar_chart_alt_2,
                        size: 45,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Gap(20),
                      const Text('No active adverts found')
                    ],
                  ),
                ),
              ]
            : userAdverts.map((listItems) => UserAdvertCard(userAdvertItem: listItems)).toList(),
      ),
    );
  }
}

class ReviewAdvertWidget extends StatelessWidget {
  const ReviewAdvertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<UserAdvertModel> userAdverts = context.watch<UserAdvertRepository>().reviewAdverts;
    return RefreshIndicator.adaptive(
      onRefresh: () async => context.read<UserAdvertRepository>().getReviewAdverts(),
      child: ListView(
        shrinkWrap: true,
        children: userAdverts.isEmpty
            ? [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(65),
                      Icon(
                        Boxicons.bx_bar_chart_alt_2,
                        size: 45,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Gap(20),
                      const Text('No review adverts found')
                    ],
                  ),
                ),
              ]
            : userAdverts.map((listItems) => UserAdvertCard(userAdvertItem: listItems)).toList(),
      ),
    );
  }
}

class ClosedAdvertWidget extends StatelessWidget {
  const ClosedAdvertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<UserAdvertModel> userAdverts = context.watch<UserAdvertRepository>().closedAdverts;
    return RefreshIndicator.adaptive(
      onRefresh: () async => context.read<UserAdvertRepository>().getClosedAdverts(),
      child: ListView(
        shrinkWrap: true,
        children: userAdverts.isEmpty
            ? [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(65),
                      Icon(
                        Boxicons.bx_bar_chart_alt_2,
                        size: 45,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Gap(20),
                      const Text('No closed adverts found')
                    ],
                  ),
                ),
              ]
            : userAdverts.map((listItems) => UserAdvertCard(userAdvertItem: listItems)).toList(),
      ),
    );
  }
}

class UserAdvertCard extends StatefulWidget {
  const UserAdvertCard({required this.userAdvertItem, super.key});
  final UserAdvertModel userAdvertItem;

  @override
  State<UserAdvertCard> createState() => _UserAdvertCardState();
}

class _UserAdvertCardState extends State<UserAdvertCard> {
  LoadState bookMakeState = LoadState.idle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black12, width: 0.99),
          borderRadius: BorderRadius.circular(12.0), // Customize the border radius here
        ),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 10),
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.userAdvertItem.images[0].source,
                placeholder: (context, url) => const SizedBox(
                    height: 10,
                    width: 10,
                    child: CupertinoActivityIndicator(
                      radius: 20.0,
                    )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      widget.userAdvertItem.title,
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatPriceToMoney(widget.userAdvertItem.price), // Replace with your product amount
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 5, top: 4, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            timeAgo(widget.userAdvertItem.createdAt), // Replace with your product amount
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                          ),
                        ),
                        widget.userAdvertItem.status == 'active'
                            ? Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.black26)),
                                      child: IconButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateAdvertScreen(userAdvertModel: widget.userAdvertItem)));
                                        },
                                        icon: const Icon(Icons.mode_edit_outline_outlined, size: 20),
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.black26)),
                                      child: IconButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          CloseAdvertBottomSheet(advertId: widget.userAdvertItem.id.toString(), advertName: widget.userAdvertItem.title).show(context);
                                        },
                                        icon: const Icon(Icons.close_rounded, size: 20),
                                      )),
                                ],
                              )
                            : widget.userAdvertItem.status == 'review'
                                ? Container(
                                    padding: const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Theme.of(context).primaryColorLight,
                                        )),
                                    child: const Text("under review"))
                                : Container(
                                    padding: const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    child: Text(widget.userAdvertItem.status)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CloseAdvertBottomSheet extends StatefulWidget {
  const CloseAdvertBottomSheet({required this.advertId, required this.advertName, super.key});
  final String advertId;
  final String advertName;
  show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      isDismissible: false,
      builder: (_) => this,
    );
  }

  @override
  State<CloseAdvertBottomSheet> createState() => _CloseAdvertBottomSheetState();
}

class _CloseAdvertBottomSheetState extends State<CloseAdvertBottomSheet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Gap(5.0),
          Container(height: 5.0, width: 70, decoration: BoxDecoration(color: const Color(0xffE0E0E0), borderRadius: BorderRadius.circular(30))),
          const Gap(5.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Are you sure?",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(25),
                  const Text(
                    "You are about to close your active advert.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(6.0),
                  Text(
                    widget.advertName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(20.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: CustomButton(
              text: isLoading
                  ? CupertinoActivityIndicator(
                      radius: 14.0,
                      color: Theme.of(context).primaryColor,
                    )
                  : const Text(
                      "Yes close Advert",
                      style: TextStyle(color: Colors.white),
                    ),
              onTap: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      context.pop();
                      await context.read<UserAdvertRepository>().closeActiveAdverts(widget.advertId, context);
                      setState(() => isLoading = false);
                    },
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: CustomButton(
              color: Colors.green,
              text: const Text(
                "No cancel",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                context.pop();
              },
            ),
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
