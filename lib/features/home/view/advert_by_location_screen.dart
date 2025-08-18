import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ilolo/features/home/model/advert_by_location_model.dart';
import 'package:ilolo/features/home/repository/advert_by_location.dart';
import 'package:ilolo/widgets/advert_card_widget.dart';
import 'package:ilolo/widgets/app_bar/custome_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AdvertByLocationScreen extends StatefulWidget {
  const AdvertByLocationScreen({required this.locationName, required this.location, super.key});
  final String locationName;
  final String location;

  @override
  State<AdvertByLocationScreen> createState() => _AdvertByLocationScreenState();
}

class _AdvertByLocationScreenState extends State<AdvertByLocationScreen> {
  String _searchQuery = '';
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchAdvertByCategory();
  }

    // implement search
  List<AdvertByLocationModel> get filteredAdvert {
    if (_searchQuery.isEmpty) {
      return context.watch<AdvertByLocationRepository>().advertsByLocation;
    } else {
      return context.watch<AdvertByLocationRepository>().advertsByLocation.where((item) => item.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  fetchAdvertByCategory() async {
    await context.read<AdvertByLocationRepository>().getAdvertsByLocation(widget.locationName, widget.location);
    setState(() => isLoaded = true);
  }

  void updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearch(
        onSearchChanged: updateSearchQuery,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("Ads from ${widget.locationName}", style: const TextStyle(fontWeight: FontWeight.w700),),
            ),
            const Gap(10),
            const Divider(),
            // display filters here
            const Divider(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.50)),
            ),
            // display grid to show advert
            isLoaded
                ? filteredAdvert.isEmpty 
                ?Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(80),
                        SvgPicture.asset("assets/images/404.svg", height: 200,),
                        const Gap(20.0),
                        const Text(
                          "No results found",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const Gap(10),
                        const Text(
                          "We couldn't find what you searched for.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  )
                :GridView.builder(
                    padding: const EdgeInsets.all(6),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.80,
                    ),
                    itemCount: filteredAdvert.length,
                    itemBuilder: (context, snapshot) {
                      final AdvertByLocationModel advert = filteredAdvert[snapshot];
                      return AdvertCardWidget(advert: advert);
                    },
                  )
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
                          const Gap(10),
                          dummyGridView(),
                          const Gap(10),
                          dummyGridView(),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      )),
    );
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
