class MessageModel {
  String? message;
  String? senderId;
  String? receiverId;
  String? dateTime;

  MessageModel({
    required this.dateTime,
    required this.message,
    required this.receiverId,
    required this.senderId,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
    };
  }
}
