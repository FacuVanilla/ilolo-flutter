class FormDataPropertyModel {
  final int id;
  final String title;
  final String label;
  final List<String> values;
  final String dataType;
  final int canFilter;
  final String createdAt;
  final String updatedAt;

  FormDataPropertyModel({
    required this.id,
    required this.title,
    required this.label,
    required this.values,
    required this.dataType,
    required this.canFilter,
    required this.createdAt,
    required this.updatedAt,
  });
}

class FormDataSubcategoryModel {
  final int id;
  final int categoryId;
  final String title;
  final String slug;
  final dynamic image;
  final String createdAt;
  final String updatedAt;
  final List<FormDataPropertyModel> properties;

  FormDataSubcategoryModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.slug,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.properties,
  });
}

class FormDataCategoryModel {
  final int id;
  final String title;
  final String slug;
  final String planType;
  final dynamic image;
  final String createdAt;
  final String updatedAt;
  final List<FormDataSubcategoryModel> subcategories;

  FormDataCategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.planType,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.subcategories,
  });
}

  // serialized this model classes and return a list
List<FormDataCategoryModel> formDataToList(jsonData){
  return (jsonData as List).map((data) =>FormDataCategoryModel(
    id: data['id'], 
    title: data['title'], 
    slug: data['slug'], 
    planType: data['plan_type'], 
    image: data['image'], 
    createdAt: data['created_at'], 
    updatedAt: data['updated_at'], 
    subcategories: (data['subcategories'] as List).map((subCategoryData) => FormDataSubcategoryModel(
      id: subCategoryData['id'], 
      categoryId: subCategoryData['category_id'], 
      title: subCategoryData['title'], 
      slug: subCategoryData['slug'], 
      image: subCategoryData['image'], 
      createdAt: subCategoryData['created_at'], 
      updatedAt: subCategoryData['updated_at'], 
      properties: (subCategoryData['properties'] as List).map((propertyData) => FormDataPropertyModel(
        id: propertyData['id'], 
        title: propertyData['title'], 
        label: propertyData['label'], 
        values: (propertyData['values'] as List).map((value) => value as String).toList(), 
        dataType: propertyData['data_type'], 
        canFilter: propertyData['can_filter'], 
        createdAt: propertyData['created_at'], 
        updatedAt: propertyData['updated_at']
        )).toList()
      )).toList()
    )).toList();
}