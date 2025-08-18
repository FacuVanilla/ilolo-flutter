class ContactModel {
  final int id;
  final String firstname;
  final String lastname;
  final dynamic phone;
  final String avatar;
  final String presence;
  final LastMessageModel? lastMessage;
  final int unseenMessages;

  ContactModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.avatar,
    required this.presence,
    required this.lastMessage,
    required this.unseenMessages,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
      avatar: json['avatar'],
      presence: json['presence'],
      lastMessage: LastMessageModel.fromJson(json['last_message']),
      unseenMessages: json['unseen_messages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'avatar': avatar,
      'presence': presence,
      'last_message': lastMessage!.toJson(),
      'unseen_messages': unseenMessages,
    };
  }
}

class LastMessageModel {
  final int id;
  final int fromId;
  final int toId;
  final String message;
  final dynamic advertId;
  final int seen;
  final String createdAt;
  final String updatedAt;

  LastMessageModel({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.message,
    this.advertId,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json['id'],
      fromId: json['from_id'],
      toId: json['to_id'],
      message: json['message'],
      advertId: json['advert_id'],
      seen: json['seen'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_id': fromId,
      'to_id': toId,
      'message': message,
      'advert_id': advertId,
      'seen': seen,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
