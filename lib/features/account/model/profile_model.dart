class ProfileDataModel {
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? facebookLink;
  final String? twitterLink;
  final String? instagramLink;
  final String? websiteLink;
  final String? businessName;
  final String? aboutBusiness;
  final String? status;
  final String? presence;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int phoneVerified;

  ProfileDataModel({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    required this.avatar,
    this.facebookLink,
    this.twitterLink,
    this.instagramLink,
    this.websiteLink,
    this.businessName,
    this.aboutBusiness,
    required this.phoneVerified,
    required this.status,
    required this.presence,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      facebookLink: json['facebook_link'],
      twitterLink: json['twitter_link'],
      instagramLink: json['instagram_link'],
      websiteLink: json['website_link'],
      businessName: json['business_name'],
      aboutBusiness: json['about_business'],
      status: json['status'],
      presence: json['presence'],
      role: json['role'],
      phoneVerified: json['phone_verified'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
