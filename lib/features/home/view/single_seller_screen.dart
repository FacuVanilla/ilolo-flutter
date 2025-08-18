import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';  // Temporarily disabled
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/app/app_middleware.dart';
import 'package:ilolo/features/home/model/advert_by_category_model.dart';
import 'package:ilolo/features/home/model/seller_model.dart';
import 'package:ilolo/features/home/repository/seller_repository.dart';
import 'package:ilolo/features/home/view/report_seller_screen.dart';
import 'package:ilolo/features/message/view/message_screen.dart';
import 'package:ilolo/widgets/advert_card_widget.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_review_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleSellerScreen extends StatefulWidget {
  const SingleSellerScreen({required this.sellerId, super.key});
  final int sellerId;
  @override
  State<SingleSellerScreen> createState() => _SingleSellerScreenState();
}

class _SingleSellerScreenState extends State<SingleSellerScreen> {
  bool isLoaded = false;
  void _onSegmentChanged(int? index) => setState(() => _selectedIndex = index!);
  int _selectedIndex = 0;
  bool _hasCallSupport = false;

  // BannerAd? _bannerAd;  // Temporarily disabled
  // bool _isAdLoaded = false;  // Temporarily disabled
  // final adUnitId = Platform.isAndroid ? 'ca-app-pub-1836719598914122/1281354786' : 'ca-app-pub-1836719598914122/5490182200';
  // // final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716'; // test adverts keys
  // void loadBannerAd() {
  //   _bannerAd = BannerAd(
  //     size: AdSize.banner,
  //     adUnitId: adUnitId,
  //     listener: BannerAdListener(
  //       // Called when an ad is successfully received.
  //       onAdLoaded: (ad) {
  //         // debugPrint('$ad loaded.');
  //         setState(() {
  //           _isAdLoaded = true;
  //         });
  //       },
  //       // Called when an ad request failed.
  //       onAdFailedToLoad: (ad, err) {
  //         debugPrint('BannerAd failed to load: $err');
  //         // Dispose the ad here to free resources.
  //         ad.dispose();
  //       },
  //     ),
  //     request: const AdRequest(),
  //   )..load();
  // }

  @override
  void initState() {
    super.initState();
    fetchSellerDetails();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() => _hasCallSupport = result);
    });
    // loadBannerAd();  // Temporarily disabled
  }

  fetchSellerDetails() async {
    await context.read<SellerRepository>().getSeller(widget.sellerId);
    setState(() => isLoaded = true);
  }

  // check if the user is authenticated before chatting a seller
  checkChatAuth(context, SellerModel sellerDetails) async {
    final bool isLogged = await authMiddleware();
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    avater: sellerDetails.avatar,
                    screenTitle: "${sellerDetails.firstname} ${sellerDetails.lastname}",
                    contactId: sellerDetails.id,
                    presence: sellerDetails.presence ?? '',
                  )));
    } else {
      GoRouter.of(context).push('/login');
    }
  }

// check if the user is authenticated before calling a seller
  checkCallAuth(context, SellerModel sellerDetails) async {
    final bool isLogged = await authMiddleware();
    if (isLogged) {
      if (_hasCallSupport) {
        _makePhoneCall(sellerDetails.phone!);
      }
    } else {
      GoRouter.of(context).push('/login');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final SellerModel? sellerDetails = context.watch<SellerRepository>().seller;
    final List<AdvertByCategoryModel>? sellerAdverts = context.watch<SellerRepository>().sellerAdverts;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Seller details"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _isAdLoaded  // Temporarily disabled
            //       ? Center(
            //         child: SizedBox(
            //             width: _bannerAd!.size.width.toDouble(),
            //             height: _bannerAd!.size.height.toDouble(),
            //             child: AdWidget(ad: _bannerAd!),
            //           ),
            //       )
            //       : const SizedBox(),
            isLoaded
                ? Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: const Color.fromRGBO(203, 213, 225, 5),
                                width: 40,
                                height: 40,
                                child: CachedNetworkImage(
                                  imageUrl: sellerDetails!.avatar,
                                  placeholder: (context, url) => const CupertinoActivityIndicator(radius: 14.0),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text("${sellerDetails.firstname} ${sellerDetails.lastname}"),
                            subtitle: const Text("No reviews found"),
                            trailing: Container(
                                padding: const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                child: Text("joined ${timeAgo(sellerDetails.createdAt!)}")),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: sellerDetails.phone == null
                                      ? null
                                      : () {
                                          checkCallAuth(context, sellerDetails);
                                        },
                                  icon: const Icon(Icons.phone_in_talk_rounded),
                                  label: const Text('Contact'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    checkChatAuth(context, sellerDetails);
                                  },
                                  icon: const Icon(Icons.chat_bubble_rounded),
                                  label: const Text('Chat now'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: CupertinoSlidingSegmentedControl(
                              children: const {
                                0: Text('About Seller'),
                                1: Text('Reviews'),
                              },
                              groupValue: _selectedIndex,
                              onValueChanged: _onSegmentChanged,
                            ),
                          ),
                        ),
                        const Gap(15),
                        _selectedIndex == 0
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: SellerBusinessDetails(description: sellerDetails.aboutBusiness ?? '', businessName: sellerDetails.businessName ?? '...'),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: SellerReview(),
                              ),
                        const Gap(5),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: CustomReviewWidget(
                            advertId: sellerDetails.id,
                          ),
                        ),
                        const Gap(5),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: CustomButton(
                            color: Colors.white,
                            onTap: () async {
                              final bool isLogged = await authMiddleware();
                              Future.microtask(() {
                                isLogged
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReportSellerScreen(
                                            sellerAvater: sellerDetails.avatar,
                                            sellerName: "${sellerDetails.firstname} ${sellerDetails.lastname}",
                                            sellerId: sellerDetails.id.toString(),
                                          ),
                                        ),
                                      )
                                    : GoRouter.of(context).push('/login');
                              });
                            },
                            text: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.flag_outlined, color: Colors.red, size: 15), Gap(5), Text("Report abuse", style: TextStyle(color: Colors.red))],
                            ),
                          ),
                        ),
                        const Gap(15),
                        Container(
                          color: Colors.blue.shade50,
                          padding: const EdgeInsets.only(left: 11, right: 11, top: 10),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(6),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.80,
                            ),
                            itemCount: sellerAdverts!.length,
                            itemBuilder: (context, snapshot) {
                              final AdvertByCategoryModel advert = sellerAdverts[snapshot];
                              return AdvertCardWidget(advert: advert);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Shimmer.fromColors(
                      baseColor: Colors.black12,
                      highlightColor: Colors.black26,
                      child: dummyDetailView(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class SellerBusinessDetails extends StatelessWidget {
  const SellerBusinessDetails({required this.description, required this.businessName, super.key});
  final String businessName;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Color.fromRGBO(248, 250, 252, 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(businessName),
          const Gap(6),
          Text(description),
        ],
      ),
    );
  }
}

class SellerReview extends StatelessWidget {
  const SellerReview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [Icon(Icons.messenger_rounded), Text("No review yet...")],
      ),
    );
  }
}

Widget dummyDetailView() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 0.0, right: 0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 30.0,
          color: Colors.white,
        ),
        const Gap(10),
        Container(
          width: 85,
          height: 20.0,
          color: Colors.white,
        ),
        const Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 120,
              height: 25.0,
              color: Colors.white,
            ),
            const Gap(5),
            Container(
              width: 85,
              height: 20.0,
              color: Colors.white,
            ),
          ],
        ),
        const Gap(10),
        Container(
          width: double.infinity,
          height: 150.0,
          color: Colors.white,
        ),
        const Gap(10),
        Container(
          width: double.infinity,
          height: 55.0,
          color: Colors.white,
        ),
        const Gap(10),
        Container(
          width: double.infinity,
          height: 200.0,
          color: Colors.white,
        ),
      ],
    ),
  );
}
