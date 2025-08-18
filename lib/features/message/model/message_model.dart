class UserMessageModel {
  final int id;
  final String firstname;
  final String lastname;
  final String avatar;

  UserMessageModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.avatar,
  });
}

class ChatImageModel {
  final int id;
  final int advertId;
  final String source;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ChatImageModel({
    required this.id,
    required this.advertId,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

    factory ChatImageModel.fromJson(Map<String, dynamic> json) {
    return ChatImageModel(
      id: json['id'],
      advertId: json['advert_id'],
      source: json['source'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class AdvertOnMessageModel {
  final int id;
  final String title;
  final int price;
  final List<ChatImageModel> images;

  AdvertOnMessageModel({
    required this.id,
    required this.title,
    required this.price,
    required this.images,
  });

  factory AdvertOnMessageModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonImages = json['images'];
    List<ChatImageModel> imagesList = jsonImages
        .map((jsonImage) => ChatImageModel.fromJson(jsonImage))
        .toList();

    return AdvertOnMessageModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      images: imagesList,
    );
  }
}

class MessageModel {
  final int id;
  final String message;
  final AdvertOnMessageModel? advert;
  final int seen;
  final String createdAt;
  final UserMessageModel from;
  final UserMessageModel to;

  MessageModel({
    required this.id,
    required this.message,
    this.advert,
    required this.seen,
    required this.createdAt,
    required this.from,
    required this.to,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'], 
      message: json['message'], 
      seen: json['seen'], 
      advert: json['advert'] != null ? AdvertOnMessageModel.fromJson(json['advert']) : null,
      createdAt: json['created_at'], 
      from: UserMessageModel(
        id: json['from']['id'], 
        firstname: json['from']['firstname'], 
        lastname: json['from']['lastname'], 
        avatar: json['from']['avatar'],
      ),
      to: UserMessageModel(
        id: json['to']['id'], 
        firstname: json['to']['firstname'], 
        lastname: json['to']['lastname'], 
        avatar: json['to']['avatar'],
      ),
    );
  }
}
