// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  late String? message;
  late String senderId;
  late String receiverId;
  late String receiverName;
  late String dateTime;
  late List? photos;
  MessageModel({
    this.message,
    required this.receiverName,
    required this.senderId,
    required this.dateTime,
    this.photos,
    required this.receiverId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'receiverName': receiverName,
      'senderId': senderId,
      'photos': photos,
      'receiverId': receiverId,
      'dateTime': dateTime,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      dateTime: map['dateTime'],
      receiverName: map['receiverName'],
      photos: map['photos'],
      message: map['message'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
    );
  }
}
