import 'package:flutter/material.dart';
import 'package:ilolo/features/home/home.dart';
import 'package:ilolo/features/home/model/category_model.dart';
import 'package:ilolo/features/home/view/advert_by_category_screen.dart';
import 'package:ilolo/widgets/app_bar/custome_app_bar_widget.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.0,
      backgroundColor: Theme.of(context).primaryColorDark,
      child: Consumer<CategoryRepository>(builder: (context, dataProvider, child) {
        final List<CategoryModel> categories = dataProvider.categories;
        return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, snapshot) {
              final CategoryModel category = categories[snapshot];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    if (category.subcategories.isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdvertByCategoryScreen(categoryName: category.title, slug: category.slug, type: 'category', ads: category.adverts,),
                          ),
                        );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubDrawerWidget(
                            subCategories: category.subcategories,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50], // Background color
                      borderRadius: BorderRadius.circular(15), // Rounded border
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 10, right: 7),
                      textColor: Theme.of(context).primaryColor,
                      title: Text(category.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis),
                      subtitle: Text(category.adverts),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}

// a screen that displace drawer subcategories
class SubDrawerWidget extends StatefulWidget {
  const SubDrawerWidget({required this.subCategories, super.key});
  final List<Subcategory> subCategories;

  @override
  State<SubDrawerWidget> createState() => _SubDrawerWidgetState();
}

class _SubDrawerWidgetState extends State<SubDrawerWidget> {
  String _searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

  // implement search
  List<Subcategory> get filteredSubCategories {
    if (_searchQuery.isEmpty) {
      return widget.subCategories;
    } else {
      return widget.subCategories.where((item) => item.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBarWithSearch(onSearchChanged: updateSearchQuery,),
      body: ListView.builder(
          itemCount: filteredSubCategories.length,
          itemBuilder: (context, snapshot) {
            final Subcategory subCategory = filteredSubCategories[snapshot];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdvertByCategoryScreen(categoryName: subCategory.title, slug: subCategory.slug, type: 'subcategory', ads: subCategory.adverts,),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Background color
                    borderRadius: BorderRadius.circular(10), // Rounded border
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 5, right: 5),
                    textColor: Theme.of(context).primaryColor,
                    title: Text(subCategory.title, style: const TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis),
                    subtitle: Text(subCategory.adverts),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
