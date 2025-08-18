class SellerModel {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String? phone;
  final String avatar;
  final String? businessName;
  final String? aboutBusiness;
  final String? status;
  final String? presence;
  final String? role;
  final String? createdAt;
  final String? updatedAt;
  final List<BusinessReviews>? businessReviews;
  SellerModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.businessName,
    required this.aboutBusiness,
    required this.status,
    required this.presence,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.businessReviews,
  });
}

class BusinessReviews {
  final int? id;
  final int? sellerId;
  final int? userId;
  final int? rating;
  final String? review;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final User? user;
  BusinessReviews(
      {required this.id,
      required this.userId,
      required this.sellerId,
      required this.rating,
      required this.review,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.user});
}

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final dynamic phone;
  final dynamic avatar;
  final String status;
  final String presence;
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
    required this.status,
    required this.presence,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });
}

SellerModel sellerData(data) {
  return SellerModel(
    id: data['id'],
    firstname: data['firstname'],
    lastname: data['lastname'],
    email: data['email'],
    phone: data['phone'],
    avatar: data['avatar'],
    businessName: data['business_name'],
    aboutBusiness: data['about_business'],
    status: data['status'],
    presence: data['presence'],
    role: data['role'],
    createdAt: data['created_at'],
    updatedAt: data['updated_at'],
    businessReviews: (data['business_reviews'] as List)
        .map((businessReviewsData) => BusinessReviews(
              id: businessReviewsData['id'],
              userId: businessReviewsData['user_id'],
              sellerId: businessReviewsData['seller_id'],
              rating: businessReviewsData['rating'],
              review: businessReviewsData['review'],
              status: businessReviewsData['status'],
              createdAt: businessReviewsData['created_at'],
              updatedAt: businessReviewsData['updated_at'],
              user: User(
                id: businessReviewsData['user']['id'],
                firstname: businessReviewsData['user']['firstname'],
                lastname: businessReviewsData['user']['lastname'],
                email: businessReviewsData['user']['email'],
                phone: businessReviewsData['user']['phone'],
                avatar: businessReviewsData['user']['avatar'],
                status: businessReviewsData['user']['status'],
                presence: businessReviewsData['user']['presence'],
                role: businessReviewsData['user']['role'],
                createdAt: businessReviewsData['user']['created_at'],
                updatedAt: businessReviewsData['user']['updated_at'],
              ),
            ))
        .toList(),
  );
}
