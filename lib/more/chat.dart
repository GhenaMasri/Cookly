import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/common/color_extension.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class ChatPage extends StatefulWidget {
  final int kitchenId;
  final int userId;
  final String type;

  ChatPage({required this.kitchenId, required this.userId, required this.type});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToBottomOnNewMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToBottomOnNewMessage() {
    FirebaseFirestore.instance
        .collection('chats')
        .doc('${widget.userId}_${widget.kitchenId}')
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      int senderId = (widget.type == 'user') ? widget.userId : widget.kitchenId;

      try {
        // Check if the chat document exists, if not, create it
        final chatDocRef = FirebaseFirestore.instance.collection('chats').doc('${widget.userId}_${widget.kitchenId}');
        final chatDocSnapshot = await chatDocRef.get();
        
        if (!chatDocSnapshot.exists) {
          await chatDocRef.set({
            'user_id': widget.userId,
            'kitchen_id': widget.kitchenId,
          });
        }

        // Add the message to Firestore
        await chatDocRef.collection('messages').add({
          'text': _controller.text,
          'userId': senderId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Send the notification
        _sendNotification();

        // Clear the text field
        _controller.clear();
        _scrollToBottom();
      } catch (error) {
        print("Failed to send message: $error");
      }
    }
  }

  void _sendNotification() async {
    int sendId = (widget.type == 'user') ? widget.userId : widget.kitchenId;
    int recId = (widget.type == 'user') ? widget.kitchenId : widget.userId;
    String recType = (widget.type == 'user') ? "chef" : "user";
    final url = '${SharedPreferencesService.url}send-notification?sendId=$sendId&recId=$recId&recType=$recType';

    try {
      await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': _controller.text,
        }),
      );
    } catch (error) {
      print('error sending notification: ${error}');
      return;
    }
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    int senderId = message['userId'];
    bool isMe = senderId == (widget.type == 'user' ? widget.userId : widget.kitchenId);

    String senderName = isMe ? 'Me' : (widget.type == 'user' ? 'Kitchen' : 'User');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            senderName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: isMe ? TColor.primary : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(15.0),
            child: Text(
              message['text'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc('${widget.userId}_${widget.kitchenId}')
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(10.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessage(message.data() as Map<String, dynamic>);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: TColor.primary, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send, color: TColor.white,),
                  backgroundColor: TColor.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
