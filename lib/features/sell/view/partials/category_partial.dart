import 'package:flutter/material.dart';
import 'package:ilolo/features/sell/model/form_data_model.dart';
import 'package:ilolo/features/sell/repository/form_data_repository.dart';
import 'package:ilolo/features/sell/repository/post_ad_repository.dart';
import 'package:ilolo/widgets/app_bar/custome_app_bar_widget.dart';
import 'package:provider/provider.dart';

class CategoryPartial extends StatefulWidget {
  const CategoryPartial({super.key});

  @override
  State<CategoryPartial> createState() => _CategoryPartialState();
}

class _CategoryPartialState extends State<CategoryPartial> {
  String _searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  // implement search
  List<FormDataCategoryModel> get filteredSubCategories {
    if (_searchQuery.isEmpty) {
      return context.read<FormDataRepository>().formDataCategories;
    } else {
      return context.read<FormDataRepository>().formDataCategories.where((item) => item.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearch(
        onSearchChanged: updateSearchQuery,
      ),
      body: ListView.builder(
          itemCount: filteredSubCategories.length,
          itemBuilder: (context, snapshot) {
            final FormDataCategoryModel category = filteredSubCategories[snapshot];
            return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  context.read<PostAdRepository>().categoryId = category.id.toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoryPartial(subCategory: category.subcategories),
                    ),
                  );
                },
                child: ListTile(
                  tileColor: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  textColor: Theme.of(context).primaryColor,
                  title: Text(category.title, style: const TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class SubCategoryPartial extends StatefulWidget {
  const SubCategoryPartial({required this.subCategory, super.key});
  final List<FormDataSubcategoryModel> subCategory;
  @override
  State<SubCategoryPartial> createState() => _SubCategoryPartialState();
}

class _SubCategoryPartialState extends State<SubCategoryPartial> {
  String _searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  // implement search
  List<FormDataSubcategoryModel> get filteredSubCategories {
    if (_searchQuery.isEmpty) {
      return widget.subCategory;
    } else {
      return widget.subCategory.where((item) => item.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearch(
        onSearchChanged: updateSearchQuery,
      ),
      body: ListView.builder(
          itemCount: filteredSubCategories.length,
          itemBuilder: (context, snapshot) {
            final FormDataSubcategoryModel subCategory = filteredSubCategories[snapshot];
            return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  context.read<PostAdRepository>().subCategoryName = subCategory.title;
                  context.read<PostAdRepository>().subCategoryId = subCategory.id.toString();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: ListTile(
                  tileColor: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  textColor: Theme.of(context).primaryColor,
                  title: Text(subCategory.title, style: const TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis),
                ),
              ),
            );
          }),
    );
  }
}
