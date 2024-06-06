import 'package:flutter/material.dart';

import 'dart:async';

import 'package:untitled/common/color_extension.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final String _myUsername = "Me";
  final String _otherUsername = "Other";

  @override
  void initState() {
    super.initState();
    // Simulate receiving a message after a delay
    Future.delayed(Duration(seconds: 3), () {
      _receiveMessage("Hello from the other side!");
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _controller.text,
          'username': _myUsername,
          'isMe': true,
        });
        _controller.clear();
      });
    }
  }

  void _receiveMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'username': _otherUsername,
        'isMe': false,
      });
    });
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    bool isMe = message['isMe'];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message['username'],
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
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
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
