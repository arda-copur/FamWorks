import 'package:cloud_firestore/cloud_firestore.dart';

final class Message {
  final String text;
  final String senderId;
  final String senderName;
  final String senderProfilePic;
  final Timestamp timestamp;

  Message({
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderProfilePic,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfilePic': senderProfilePic,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      senderProfilePic: map['senderProfilePic'],
      timestamp: map['timestamp'],
    );
  }
}
