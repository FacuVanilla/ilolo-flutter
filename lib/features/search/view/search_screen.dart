import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ilolo/features/search/model/advert_search_model.dart';
import 'package:ilolo/features/search/repository/search_repository.dart';
import 'package:ilolo/widgets/advert_card_widget.dart';
import 'package:ilolo/widgets/app_bar/custome_app_bar_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  bool isRefreshing = false;
  List<AdvertSearchModel> defaultAds = [];

  // implement search
  Future<void> filteredAdverts(String query) async {
    setState(() {
      _searchQuery = query;
      isRefreshing = true;
    });
    await context.read<SearchRepository>().searchAdverts(_searchQuery.toLowerCase());
    setState(() {
      defaultAds = context.read<SearchRepository>().advertSearchResult;
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearch(
        onSearchChanged: filteredAdverts,
        focus: true,
      ),
      body: isRefreshing
          ? const Center(
            child: CupertinoActivityIndicator(radius: 20.0,)
            )
          : GridView.builder(
              padding: const EdgeInsets.all(6),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.80,
              ),
              itemCount: defaultAds.length,
              itemBuilder: (context, snapshot) {
                final AdvertSearchModel advert = defaultAds[snapshot];
                return AdvertCardWidget(advert: advert);
              },
            ),
    );
  }
}
