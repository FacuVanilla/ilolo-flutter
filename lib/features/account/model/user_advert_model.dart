class ImageOnUserAdvertModel {
  final int id;
  final int advertId;
  final String source;
  final String createdAt;
  final String updatedAt;

  ImageOnUserAdvertModel({
    required this.id,
    required this.advertId,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageOnUserAdvertModel.fromJson(Map<String, dynamic> json) {
    return ImageOnUserAdvertModel(
      id: json['id'],
      advertId: json['advert_id'],
      source: json['source'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class UserAdvertModel {
  final int id;
  final int userId;
  final int categoryId;
  final int subcategoryId;
  final String title;
  final String slug;
  final String description;
  final dynamic type;
  final int price;
  final int negotiable;
  final String state;
  final String lga;
  final int views;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<ImageOnUserAdvertModel> images;

  UserAdvertModel({
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
    required this.images,
  });

  factory UserAdvertModel.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List;
    List<ImageOnUserAdvertModel> imagesList = imagesJson.map((image) => ImageOnUserAdvertModel.fromJson(image)).toList();

    return UserAdvertModel(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      type: json['type'],
      price: json['price'],
      negotiable: json['negotiable'],
      state: json['state'],
      lga: json['lga'],
      views: json['views'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      images: imagesList,
    );
  }
}