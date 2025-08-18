import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/app/app_helper.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/book_mark/repository/book_mark_repository.dart';
import 'package:ilolo/features/home/home.dart';
import 'package:ilolo/features/home/model/special_advert_model.dart';
import 'package:ilolo/features/home/repository/location_repository.dart';
import 'package:ilolo/features/home/view/single_advert_screen.dart';
import 'package:ilolo/widgets/advert_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: ()async{
            final advertRepository = context.read<AdvertRepository>();
            final categoryRepository = context.read<CategoryRepository>();
            final locationRepository = context.read<LocationRepository>();
            final profileRepository = context.read<ProfileRepository>();
            final bookmarkRepository = context.read<BookMarkRepository>();

            await advertRepository.getAdverts();
            await categoryRepository.getCategories();
            await locationRepository.getStateAndLga();
            await profileRepository.getProfileData();
            await bookmarkRepository.getBookMarks();
          },
          child: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 16),
              child: Text(
                "Special offers",
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              height: 230,
              child: Consumer<AdvertRepository>(
                builder: (context, dataProvider, child) {
                  final List<SpecialAdvertModel> specialAds = dataProvider.specialAdverts;
                  return ListView(
                      padding: const EdgeInsets.only(top: 10, right: 10, left: 6),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: context.watch<AdvertRepository>().isLoaded
                          ? specialAds
                              .map(
                                (snapshot) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleAdvertScreen(
                                          images: snapshot.images,
                                          category: snapshot.category,
                                          subcategory: " / ${snapshot.subcategory}",
                                          advertId: snapshot.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(right: 10),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                      borderRadius: BorderRadius.circular(12.0), // Customize the border radius here
                                    ),
                                    elevation: 0.50,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.images[0].source,
                                              placeholder: (context, url) => const SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CupertinoActivityIndicator(
                                                    radius: 20.0,
                                                  )),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              fit: BoxFit.cover,
                                              width: 200,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                truncate(snapshot.title, 30),
                                                style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                formatPriceToMoney(snapshot.price),
                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                          : <Widget>[
                              specialAdsDummy()
                            ]);
                },
              ),
            ),
            // const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Trending ads",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
              ),
            ),
            context.watch<AdvertRepository>().isLoaded 
            ? Consumer<AdvertRepository>(builder: (context, dataProvider, child) {
              final List<AdvertModel> ads = dataProvider.adverts;
              return GridView.builder(
                padding: const EdgeInsets.all(6),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                ),
                itemCount: ads.length,
                itemBuilder: (context, snapshot) {
                  final AdvertModel advert = ads[snapshot];
                  return AdvertCardWidget(advert: advert);
                },
              );
            })
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                decoration: const BoxDecoration(color: Colors.white),
                child: Shimmer.fromColors(
                  baseColor: Colors.black12,
                  highlightColor: Colors.black26,
                  child: Column(
                    children: [
                      dummyGridView(),
                      const Gap(10),
                      dummyGridView(),
                    ],
                  ),
                ),
              )
          ],
              ),
            ),
        ));
  }
}

Widget dummyGridView() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0.0, left: 0.0, right: 0.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 230.0,
           decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Container(
            height: 230.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

Widget specialAdsDummy() {
  return Shimmer.fromColors(
    baseColor: Colors.black12,
    highlightColor: Colors.black26,
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          width: 200,
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          width: 200,
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          width: 200,
        ),
      ],
    ),
  );
}
