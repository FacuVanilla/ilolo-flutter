class SingleAdvertModel {
  final int id;
  final int userId;
  final int categoryId;
  final int subcategoryId;
  final String title;
  final String slug;
  final String description;
  final int price;
  final bool negotiable;
  final String state;
  final String lga;
  final int views;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<AdvertImage> images;
  final Category category;
  final Subcategory subcategory;
  final List<Property> properties;
  final User user;
  // final List<Review> reviews;

  SingleAdvertModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.negotiable,
    required this.state,
    required this.lga,
    required this.views,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.category,
    required this.subcategory,
    required this.properties,
    required this.user,
    // required this.reviews,
  });
}

class AdvertImage {
  final int id;
  final int advertId;
  final String source;
  final String createdAt;
  final String updatedAt;

  AdvertImage({
    required this.id,
    required this.advertId,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Category {
  final int id;
  final String title;
  final String slug;
  final String planType;
  final String? image;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.title,
    required this.slug,
    required this.planType,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Subcategory {
  final int id;
  final int categoryId;
  final String title;
  final String slug;
  final String? image;
  final String createdAt;
  final String updatedAt;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.slug,
    this.image,
    required this.createdAt,
    required this.updatedAt,
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

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final dynamic phone;
  final dynamic avatar;
  final String? facebookLink;
  final String? twitterLink;
  final String? instagramLink;
  final String? websiteLink;
  final String? businessName;
  final String? aboutBusiness;
  final String status;
  final String? presence;
  final String role;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.avatar,
    this.facebookLink,
    this.twitterLink,
    this.instagramLink,
    this.websiteLink,
    this.businessName,
    this.aboutBusiness,
    required this.status,
    required this.presence,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });
}

// serialized the advert detail and return a list
SingleAdvertModel singleAdvertToList(data) {
  return SingleAdvertModel(
    id: data['id'],
    userId: data['user_id'],
    categoryId: data['category_id'],
    subcategoryId: data['subcategory_id'],
    title: data['title'],
    slug: data['slug'],
    description: data['description'],
    price: data['price'],
    negotiable: data['negotiable'] == 1 ? true : false,
    state: data['state'],
    lga: data['lga'],
    views: data['views'],
    status: data['status'],
    createdAt: data['created_at'],
    updatedAt: data['updated_at'],
    images: (data['images'] as List)
        .map((imageData) => AdvertImage(
          id: imageData['id'], 
          advertId: imageData['advert_id'], 
          source: imageData['source'], 
          createdAt: imageData['created_at'], 
          updatedAt: imageData['updated_at'],
        )).toList(),
    category: Category(
      id: data['category']['id'],
      title: data['category']['title'],
      slug: data['category']['slug'],
      planType: data['category']['plan_type'],
      createdAt: data['category']['created_at'],
      updatedAt: data['category']['updated_at'],
    ),
    subcategory: Subcategory(
      id: data['subcategory']['id'],
      categoryId: data['subcategory']['category_id'],
      title: data['subcategory']['title'],
      slug: data['subcategory']['slug'],
      createdAt: data['subcategory']['created_at'],
      updatedAt: data['subcategory']['updated_at'],
    ),
    properties: (data['properties'] as List)
        .map((propertyData) => Property(
              property: propertyData['property'],
              value: propertyData['value'],
              dataType: propertyData['data_type'],
            ))
        .toList(),
    user: User(
      id: data['user']['id'],
      firstname: data['user']['firstname'],
      lastname: data['user']['lastname'],
      email: data['user']['email'],
      phone: data['user']['phone'],
      avatar: data['user']['avatar'],
      status: data['user']['status'],
      presence: data['user']['presence'],
      role: data['user']['role'],
      createdAt: data['user']['created_at'],
      updatedAt: data['user']['updated_at'],
    ),
  );
}
