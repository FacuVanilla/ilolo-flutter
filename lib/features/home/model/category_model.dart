class Subcategory {
  final int id;
  final String title;
  final String slug;
  final String adverts;

  Subcategory({
    required this.id,
    required this.title,
    required this.slug,
    required this.adverts,
  });
}

class CategoryModel {
  final int id;
  final String title;
  final String slug;
  final String adverts;
  final List<Subcategory> subcategories;

  CategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.adverts,
    required this.subcategories,
  });
}

// serialized the adverts and return a list
List<CategoryModel> categoryToList(jsonData) {
  return (jsonData as List).map((data) => CategoryModel(
    id: data['id'], 
    title: data['title'], 
    slug: data['slug'], 
    adverts: data['adverts'], 
    subcategories: (data['subcategories'] as List).map((subcategoriesData) => Subcategory(
      id: subcategoriesData['id'], 
      title: subcategoriesData['title'], 
      slug: subcategoriesData['slug'], 
      adverts: subcategoriesData['adverts'],
    )).toList()
  )).toList();
}
