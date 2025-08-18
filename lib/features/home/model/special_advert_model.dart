class SpecialAdvertModel {
  final int id;
  final int userId;
  final int categoryId;
  final int subcategoryId;
  final String title;
  final String slug;
  final String description;
  final String type;
  final int price;
  final int negotiable;
  final String state;
  final String lga;
  final int views;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String category;
  final String subcategory;
  final List<Image> images;
  final List<Property> properties;

  SpecialAdvertModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
    required this.title,
    required this.slug,
    required this.description,
    required this.type,
    required this.price,
    required this.negotiable,
    required this.state,
    required this.lga,
    required this.views,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.subcategory,
    required this.images,
    required this.properties,
  });
}

class Image {
  final int id;
  final int advertId;
  final String source;
  final String createdAt;
  final String updatedAt;

  Image({
    required this.id,
    required this.advertId,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Property {
  final String property;
  final String value;
  final String dataType;

  Property({
    required this.property,
    required this.value,
    required this.dataType,
  });
}

// serialized the adverts and return a list
  List<SpecialAdvertModel> specialAdvertsToList(jsonData) {
    return (jsonData as List)
      .map((data) => SpecialAdvertModel(
            id: data['id'],
            userId: data['user_id'],
            categoryId: data['category_id'],
            subcategoryId: data['subcategory_id'],
            title: data['title'],
            slug: data['slug'],
            description: data['description'],
            type: data['type'],
            price: data['price'],
            negotiable: data['negotiable'],
            state: data['state'],
            lga: data['lga'],
            views: data['views'],
            status: data['status'],
            createdAt: data['created_at'],
            updatedAt: data['updated_at'],
            category: data['category'],
            subcategory: data['subcategory'],
            properties: (data['properties'] as List)
                .map((propertyData) => Property(
                      property: propertyData['property'],
                      value: propertyData['value'],
                      dataType: propertyData['data_type'],
                    ))
                .toList(),
            images: (data['images'] as List)
                .map((imageData) => Image(
                      id: imageData['id'],
                      advertId: imageData['advert_id'],
                      source: imageData['source'],
                      createdAt: imageData['created_at'],
                      updatedAt: imageData['updated_at'],
                    ))
                .toList(),
          ))
      .toList();
  }