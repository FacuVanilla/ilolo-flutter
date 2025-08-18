import 'package:ilolo/features/home/model/images_model.dart';

class AdvertModel {
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
  final dynamic badge;
  final List<Property> properties;
  final List<ImageModel> images;

  AdvertModel({
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
    required this.badge,
    required this.properties,
    required this.images,
  });
}

class Property {
  final String property;
  final dynamic value;
  final String dataType;

  Property({
    required this.property,
    required this.value,
    required this.dataType,
  });
}

  // serialized the adverts and return a list
  List<AdvertModel> advertsToList(jsonData) {
    
    return (jsonData as List)
      .map((data) => AdvertModel(
            id: data['id'],
            userId: data['user_id'],
            categoryId: data['category_id'],
            subcategoryId: data['subcategory_id'],
            title: data['title'],
            slug: data['slug'],
            description: data['description'],
            type: data['type'] ?? '',
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
            badge: data['badge'],
            properties: (data['properties'] as List)
                .map((propertyData) => Property(
                      property: propertyData['property'],
                      value: propertyData['value'],
                      dataType: propertyData['data_type'],
                    ))
                .toList(),
            images: (data['images'] as List)
                .map((imageData) => ImageModel(
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