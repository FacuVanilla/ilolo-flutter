import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';  // Temporarily disabled
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/app/app_middleware.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/book_mark/model/book_mark_model.dart';
import 'package:ilolo/features/book_mark/repository/book_mark_repository.dart';
import 'package:ilolo/features/home/model/single_advert_model.dart';
import 'package:ilolo/features/home/repository/single_advert_repository.dart';
import 'package:ilolo/features/home/view/report_seller_screen.dart';
import 'package:ilolo/features/home/view/single_seller_screen.dart';
import 'package:ilolo/features/message/view/message_screen.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:ilolo/widgets/button_widget.dart';
import 'package:ilolo/widgets/custom_icon_button.dart';
import 'package:ilolo/widgets/custom_review_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleAdvertScreen extends StatefulWidget {
  const SingleAdvertScreen(
      {required this.advertId,
      required this.images,
      this.category = '',
      this.subcategory = '',
      super.key});
  final List<dynamic> images;
  final int advertId;
  final String? category;
  final String? subcategory;
  @override
  State<SingleAdvertScreen> createState() => _SingleAdvertScreenState();
}

class _SingleAdvertScreenState extends State<SingleAdvertScreen> {
  int _currentIndex = 0;
  bool isLoaded = false;
  int _selectedIndex = 0;
  LoadState bookMakeState = LoadState.idle;
  bool _hasCallSupport = false;

  // BannerAd? _bannerAd;  // Temporarily disabled
  // bool _isAdLoaded = false;  // Temporarily disabled
  // final adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-1836719598914122/1281354786'
  //     : 'ca-app-pub-1836719598914122/5490182200';
  // // final adUnitId = Platform.isAndroid ? 'ca-app-pub-1836719598914122/1281354786' : 'ca-app-pub-3940256099942544/2934735716';
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

  void _onSegmentChanged(int? index) => setState(() => _selectedIndex = index!);

  @override
  void initState() {
    super.initState();
    fetchAdvertDetails();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() => _hasCallSupport = result);
    });
    // loadBannerAd();  // Temporarily disabled
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  fetchAdvertDetails() async {
    await context
        .read<SingleAdvertRepository>()
        .getSingleAdvert(widget.advertId);
    setState(() => isLoaded = true);
  }

// check if the user is authenticated before chatting a seller
  checkChatAuth(context, SingleAdvertModel adsDetail) async {
    final bool isLogged = await authMiddleware();
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    avater: adsDetail.user.avatar,
                    screenTitle:
                        "${adsDetail.user.firstname} ${adsDetail.user.lastname}",
                    contactId: adsDetail.user.id,
                    presence: adsDetail.user.presence ?? '',
                    advert: adsDetail,
                  )));
    } else {
      GoRouter.of(context).push('/login');
    }
  }

// check if the user is authenticated before calling a seller
  checkCallAuth(context, SingleAdvertModel adsDetail) async {
    final bool isLogged = await authMiddleware();
    if (isLogged) {
      if (_hasCallSupport) {
        _makePhoneCall(adsDetail.user.phone);
      }
    } else {
      GoRouter.of(context).push('/login');
    }
  }

  checkPostAdsAuth(context) async {
    final bool isLogged = await authMiddleware();
    if (isLogged) {
      if (Provider.of<ProfileRepository>(context, listen: false)
              .profileData!
              .phoneVerified ==
          0) {
        GoRouter.of(context).push('/verify-phone');
      } else {
        GoRouter.of(context).pop();
        GoRouter.of(context).go('/home/sell');
      }
    } else {
      GoRouter.of(context).push('/login');
    }
  }

  void _showNextImage() => setState(
      () => _currentIndex = (_currentIndex + 1) % widget.images.length);

  void _showPreviousImage() => setState(() => _currentIndex =
      (_currentIndex - 1 + widget.images.length) % widget.images.length);

  @override
  Widget build(BuildContext context) {
    final SingleAdvertModel? adsDetail =
        context.read<SingleAdvertRepository>().singleAdvert;
    List<BookMarkDataModel> bookMarks =
        context.watch<BookMarkRepository>().bookMarkAdverts;
    bool existInBook =
        bookMarks.any((element) => element.advertId == widget.advertId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: const TextStyle(fontSize: 13),
        title: Text('${widget.category} ${widget.subcategory}'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: const Color.fromARGB(250, 255, 255, 255),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: bookMakeState == LoadState.idle
                ? IconButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      final bool isLogged = await authMiddleware();
                      Future.microtask(() async {
                        if (isLogged) {
                          setState(() => bookMakeState = LoadState.loading);
                          Map<String, dynamic> data = {
                            'advert_id': widget.advertId.toString()
                          };
                          existInBook
                              ? await context
                                  .read<BookMarkRepository>()
                                  .removeBookMark(data, context)
                              : await context
                                  .read<BookMarkRepository>()
                                  .addBookmark(data, context);
                          setState(() => bookMakeState = LoadState.idle);
                        } else {
                          GoRouter.of(context).push('/login');
                        }
                      });
                    },
                    icon: Icon(
                      existInBook
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 20,
                    ),
                  )
                : SizedBox(
                    height: 20,
                    width: 20,
                    child: CupertinoActivityIndicator(
                        radius: 12.0, color: Theme.of(context).primaryColor)),
          ),
          const Gap(3),
          CustomIconButton(
              onPressed: () {
                DialogAlert()
                    .show(context, color: Colors.white, actions: moreActions());
              },
              icon: Icons.more_vert),
          const Gap(5),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // _isAdLoaded  // Temporarily disabled
              //     ? SizedBox(
              //         width: _bannerAd!.size.width.toDouble(),
              //         height: _bannerAd!.size.height.toDouble(),
              //         child: AdWidget(ad: _bannerAd!),
              //       )
              //     : const SizedBox(),

              ClipRRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: const Color.fromRGBO(203, 213, 225, 5),
                      height: 300,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          MultiImageProvider multiImageProvider =
                              MultiImageProvider(
                            widget.images
                                .map((image) =>
                                    Image.network(image.source).image)
                                .toList(),
                          );
                          showImageViewerPager(context, multiImageProvider,
                              backgroundColor: Colors.black87,
                              useSafeArea: false,
                              swipeDismissible: true,
                              doubleTapZoomable: true);
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.images[_currentIndex].source,
                          placeholder: (context, url) => const SizedBox(
                            height: 50,
                            width: 50,
                            child: CupertinoActivityIndicator(
                              radius: 20.0,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _showPreviousImage,
                          icon: const Icon(Icons.navigate_before),
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: _showNextImage,
                          icon: const Icon(Icons.navigate_next),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: Container(
                    //     height: 30,
                    //     width: 50,
                    //     padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black12.withOpacity(0.5),
                    //       borderRadius: const BorderRadius.only(topLeft: Radius.circular(5)),
                    //     ),
                    //     child: Image.asset(
                    //       'assets/images/gold.png',
                    //       height: 20,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: 30,
                        width: 50,
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5)),
                        ),
                        child: Center(
                          child: Text(
                            ' ${_currentIndex + 1} / ${widget.images.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: widget.images.map((model) {
              //     int index = widget.images.indexOf(model);
              //     return Container(
              //       width: 10,
              //       height: 10,
              //       margin: const EdgeInsets.symmetric(horizontal: 2),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: _currentIndex == index ? Colors.blue : Colors.grey,
              //       ),
              //     );
              //   }).toList(),
              // ),
              isLoaded
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(adsDetail!.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const Gap(10),
                          adsDetail.status == 'active'
                              ? Container(
                                  padding: const EdgeInsets.only(
                                      top: 3, bottom: 3, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  child: const Text("Promoted"),
                                )
                              : const SizedBox(),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(formatPriceToMoney(adsDetail.price),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  const Gap(5),
                                  adsDetail.negotiable
                                      ? const Text("(Negotiable)")
                                      : const SizedBox(),
                                ],
                              ),
                              Row(children: [
                                const Icon(
                                  Icons.visibility_outlined,
                                  size: 16,
                                ),
                                const Gap(4),
                                Text(adsDetail.views.toString())
                              ]),
                            ],
                          ),
                          const Gap(18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.4),
                                child: Row(children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    size: 16,
                                  ),
                                  const Gap(4),
                                  Text(timeAgo(adsDetail.createdAt))
                                ]),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.4),
                                child: Row(children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                  ),
                                  const Gap(4),
                                  Flexible(
                                    child: Text(
                                      '${adsDetail.state}, ${adsDetail.lga}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                          const Gap(10),
                          // ================================================================""
                          // ================================================================
                          const Divider(color: Color.fromARGB(13, 0, 0, 0)),
                          // const Gap(15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: adsDetail.properties
                                .map((e) => ListTile(
                                      title: Text(e.property.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                      trailing: Text(
                                          e.value.toString().toLowerCase(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                    ))
                                .toList(),
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: adsDetail.properties
                          //       .map((e) => Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text(e.property.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          //               const Gap(10),
                          //               Text(e.value.toString().toLowerCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
                          //             ],
                          //           ),
                          //           ListTile(
                          //             title: Text(e.property.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          //             trailing: Text(e.value.toString().toLowerCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                          //             )
                          //           )
                          //       .toList(),
                          // ),
                          // const Gap(15),
                          const Divider(color: Color.fromARGB(13, 0, 0, 0)),
                          const Gap(10),
                          // ================================================================""
                          // ================================================================
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity, // Full width
                                child: CupertinoSlidingSegmentedControl(
                                  children: const {
                                    0: Text('Description'),
                                    1: Text('Reviews'),
                                  },
                                  groupValue: _selectedIndex,
                                  onValueChanged: _onSegmentChanged,
                                ),
                              ),
                              const Gap(15),
                              _selectedIndex == 0
                                  ? AdvertDescription(
                                      description: adsDetail.description)
                                  : const AdvertReview(),
                            ],
                          ),
                          // ================================================================
                          // ================================================================
                          const Divider(color: Color.fromARGB(13, 0, 0, 0)),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingleSellerScreen(
                                          sellerId: adsDetail.userId)));
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: const Color.fromRGBO(203, 213, 225, 5),
                                width: 40,
                                height: 40,
                                child: CachedNetworkImage(
                                  imageUrl: adsDetail.user.avatar,
                                  placeholder: (context, url) =>
                                      const CupertinoActivityIndicator(
                                          radius: 14.0),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                                "${adsDetail.user.firstname} ${adsDetail.user.lastname}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: const Text("No reviews found",
                                style: TextStyle(color: Colors.black26)),
                            trailing: Container(
                                padding: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 5, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                child: Text(
                                    "joined ${timeAgo(adsDetail.user.createdAt)}")),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: adsDetail.user.phone == null
                                      ? null
                                      : () {
                                          checkCallAuth(context, adsDetail);
                                        },
                                  icon: const Icon(Icons.phone_in_talk_rounded),
                                  label: const Text('Contact'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
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
                                    checkChatAuth(context, adsDetail);
                                  },
                                  icon: const Icon(Icons.chat_bubble_rounded),
                                  label: const Text('Chat now'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(6),
                          const Divider(color: Color.fromARGB(13, 0, 0, 0)),
                          const Gap(6),
                          CustomReviewWidget(advertId: adsDetail.id),
                          const Gap(6),
                          const Divider(color: Color.fromARGB(13, 0, 0, 0)),
                          const Gap(6),
                          const Text("Safety Precaution",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17)),
                          const Gap(4),
                          const Text(
                            "Remember, don't send any pre-payments. Meet the seller at a safe public place.Inspect the goods to make sure they meet your needs. Check all documentation and only pay if you're satisfied.",
                            style: TextStyle(
                                color: Colors.black38, fontSize: 15.0),
                          ),
                          const Gap(6),
                          const Divider(color: Color.fromARGB(13, 0, 0, 0)),
                          const Gap(6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final bool isLogged =
                                        await authMiddleware();
                                    Future.microtask(
                                      () {
                                        isLogged
                                            ? UnavailableBottomSheet(
                                                    advertId:
                                                        adsDetail.id.toString())
                                                .show(context)
                                            : GoRouter.of(context)
                                                .push('/login');
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.do_not_disturb_off_outlined,
                                      size: 15),
                                  label: const Text('Mark unavailable'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final bool isLogged =
                                        await authMiddleware();
                                    Future.microtask(() {
                                      isLogged
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportSellerScreen(
                                                  sellerAvater:
                                                      adsDetail.user.avatar,
                                                  sellerName:
                                                      "${adsDetail.user.firstname} ${adsDetail.user.lastname}",
                                                  sellerId: adsDetail.user.id
                                                      .toString(),
                                                ),
                                              ),
                                            )
                                          : GoRouter.of(context).push('/login');
                                    });
                                  },
                                  icon: const Icon(Boxicons.bx_flag, size: 15),
                                  label: const Text('Report abuse'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
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
      ),
    );
  }

  List<Widget> moreActions() => [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            tileColor: mainColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            onTap: () async {
              await Share.share(
                  'check this out https://ilolo.ng/advert/${context.read<SingleAdvertRepository>().singleAdvert!.slug}');
            },
            leading:
                const Icon(Icons.share_rounded, color: Colors.white, size: 17),
            title: const Text(
              "Share this Ad",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const Gap(10),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            tileColor: mainColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            onTap: () {
              checkPostAdsAuth(context);
            },
            leading: const Icon(Icons.post_add_rounded,
                color: Colors.white, size: 17),
            title: const Text("Post Ad like this",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900)),
          ),
        ),
        const Gap(10),
        // Container(
        //   margin: const EdgeInsets.only(bottom: 10),
        //   child: ListTile(
        //     tileColor: mainColor,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //     onTap: () {},
        //     leading: const Icon(Icons.dangerous_rounded, color: Colors.white, size: 17),
        //     title: const Text("Stop showing this Ad", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
        //   ),
        // )
      ];
}

class AdvertDescription extends StatelessWidget {
  const AdvertDescription({required this.description, super.key});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Color.fromRGBO(248, 250, 252, 1)),
      child: Text(description),
    );
  }
}

class AdvertReview extends StatelessWidget {
  const AdvertReview({super.key});

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

class UnavailableBottomSheet extends StatefulWidget {
  const UnavailableBottomSheet({required this.advertId, super.key});
  final String advertId;

  show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
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
  State<UnavailableBottomSheet> createState() => _UnavailableBottomSheetState();
}

class _UnavailableBottomSheetState extends State<UnavailableBottomSheet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // print(distance.toStringAsFixed(2));
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Gap(5.0),
          Container(
              height: 5.0,
              width: 70,
              decoration: BoxDecoration(
                  color: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(30))),
          const Gap(20.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              // color: const Color.fromARGB(40, 2, 80, 100),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Is this no longer available? 😢",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(25),
                  Image.asset(
                    'assets/images/not_available.png',
                    height: 80,
                  ),
                  const Gap(12),
                  const Text(
                    "We'll do our best to close this advert if it's not available.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10.0),
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
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
              onTap: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      // Map<String, dynamic> data = {'id': widget.order['id'].toString()};
                      // print(data);
                      await context
                          .read<SingleAdvertRepository>()
                          .unavailable(widget.advertId, context);
                      // context.pop();
                      // await _tripController.acceptTrip(data, context);
                      // Navigator.pop(context);
                      setState(() => isLoading = false);
                      // Future.microtask(() => context.pop());
                    },
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: CustomButton(
              color: Colors.green,
              text: const Text(
                "Cancel",
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
