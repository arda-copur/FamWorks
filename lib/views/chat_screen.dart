import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_works/constants/app_colors.dart';
import 'package:fam_works/constants/app_paddings.dart';
import 'package:fam_works/feature/services/firebase_service.dart';
import 'package:fam_works/feature/utils/app_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String homeCode;

  const ChatScreen({required this.homeCode});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.homeCode)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message['text'];
                  final messageSenderName = message['senderName'];
                  final messageSenderProfilePic = message['senderProfilePic'];
                  final currentUser = FirebaseAuth.instance.currentUser!.uid;

                  final messageWidget = MessageBubble(
                    text: messageText,
                    senderName: messageSenderName,
                    senderProfilePic: messageSenderProfilePic,
                    isMe: currentUser == message['senderId'],
                  );
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  children: messageWidgets,
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.white),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const AppPaddings.allSmall(),
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        // Do something with the user input.
                      },
                      decoration: const InputDecoration(
                        hintText: 'Mesaj gönderin...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.white,fontWeight: FontWeight.w300)
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.white),
                  onPressed: () {
                    service.sendMessage(messageController, widget.homeCode);
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String text;
  final String senderName;
  final String senderProfilePic;
  final bool isMe;
  final Color bubbleColor = const Color.fromARGB(255, 67, 78, 132);

  const MessageBubble({
    Key? key,
    required this.text,
    required this.senderName,
    required this.senderProfilePic,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 15,
                  backgroundImage: senderProfilePic.isNotEmpty 
                    ? NetworkImage(senderProfilePic)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(width: 8),
              ],
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? const Radius.circular(30.0) : const Radius.circular(0.0),
                  topRight: isMe ? const Radius.circular(0.0) : const Radius.circular(30.0),
                  bottomLeft: const Radius.circular(30.0),
                  bottomRight: const Radius.circular(30.0),
                ),
                color: isMe ? bubbleColor : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black54,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 15,
                  backgroundImage: senderProfilePic.isNotEmpty 
                    ? NetworkImage(senderProfilePic)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
              ],
            ],
          ),
          const AppHeightBox(height: 2),
          Text(
            senderName,
            style: TextStyle(
              fontSize: 10.0,
              color: isMe ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
