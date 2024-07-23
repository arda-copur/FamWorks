import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String homeCode;

  const ChatScreen({required this.homeCode});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final Color bgColor = const Color(0xFF1C2341);
  final Color containerColor =  const Color(0xFF272D4A);
  final Color white = Colors.white;

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      var userName = userDoc['name'];
      var userProfilePic = userDoc['profilePic'];

      FirebaseFirestore.instance.collection('chats').doc(widget.homeCode).collection('messages').add({
        'text': _messageController.text,
        'senderId': currentUser.uid,
        'senderName': userName,
        'senderProfilePic': userProfilePic,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
                top: BorderSide(color: Colors.white),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _messageController,
                      onChanged: (value) {
                        // Do something with the user input.
                      },
                      decoration: InputDecoration(
                        hintText: 'Mesaj gönderin...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: white,fontWeight: FontWeight.w300)
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: white),
                  onPressed: _sendMessage,
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
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
                SizedBox(width: 8),
              ],
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(30.0) : Radius.circular(0.0),
                  topRight: isMe ? Radius.circular(0.0) : Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
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
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 15,
                  backgroundImage: senderProfilePic.isNotEmpty 
                    ? NetworkImage(senderProfilePic)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
              ],
            ],
          ),
          SizedBox(height: 2),
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
