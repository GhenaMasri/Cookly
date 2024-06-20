import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/more/chat.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class InboxPage extends StatelessWidget {
  final int id; // Can be user ID or kitchen ID
  final String type; // Can be 'user' or 'chef'

  InboxPage({required this.id, required this.type});

  Future<Map<String, dynamic>> getLastMessage(String chatId) async {
    final messages = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (messages.docs.isNotEmpty) {
      return messages.docs.first.data();
    }
    return {};
  }

  Future<String> getSenderName(int senderId, String senderType) async {
    final url =
        '${SharedPreferencesService.url}get-user-name?senderId=$senderId&senderType=$senderType';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['senderName'];
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        title: Text(
          'Inbox',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 230, 81, 0)),
            ));
          }
          final chats = snapshot.data!.docs.where((doc) {
            final ids = doc.id.split('_').map((e) => int.parse(e)).toList();
            return ids.contains(id);
          }).toList();

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return FutureBuilder(
                future: getLastMessage(chat.id),
                builder: (context,
                    AsyncSnapshot<Map<String, dynamic>> lastMessageSnapshot) {
                  if (!lastMessageSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 230, 81, 0)),
                    ));
                  }
                  final lastMessage = lastMessageSnapshot.data!;
                  final otherId = chat.id
                      .split('_')
                      .map((e) => int.parse(e))
                      .firstWhere((element) => element != id);

                  return FutureBuilder(
                    future: getSenderName(
                        otherId, type == 'user' ? 'chef' : 'user'),
                    builder:
                        (context, AsyncSnapshot<String> senderNameSnapshot) {
                      if (!senderNameSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 230, 81, 0)),
                        ));
                      }
                      final senderName = senderNameSnapshot.data!;
                      final isRead = lastMessage['userId'] == id;
                      return InboxItemWidget(
                        inboxItem: InboxItem(
                          senderName: senderName,
                          lastMessageTime:
                              lastMessage['timestamp'].toDate().toString(),
                          isRead: isRead,
                          chatId: chat.id, // pass the chat ID here
                        ),
                        userId: id,
                        userType: type,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class InboxItem {
  final String senderName;
  final String lastMessageTime;
  final bool isRead;
  final String chatId;

  InboxItem({
    required this.senderName,
    required this.lastMessageTime,
    required this.isRead,
    required this.chatId,
  });
}

class InboxItemWidget extends StatelessWidget {
  final InboxItem inboxItem;
  final int userId; // the id of the user who opened the inbox
  final String userType; // the type of the user who opened the inbox

  InboxItemWidget({
    required this.inboxItem,
    required this.userId,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          final ids =
              inboxItem.chatId.split('_').map((e) => int.parse(e)).toList();
          int kitchenId, userId;

          if (userType == 'user') {
            userId = this.userId;
            kitchenId = ids.firstWhere((element) => element != userId);
          } else {
            kitchenId = this.userId;
            userId = ids.firstWhere((element) => element != kitchenId);
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                kitchenId: kitchenId,
                userId: userId,
                type: userType,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    inboxItem.isRead ? Colors.grey : TColor.primary,
                child: Text(
                  inboxItem.senderName[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          inboxItem.senderName,
                          style: TextStyle(
                            fontWeight: inboxItem.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            color: inboxItem.isRead
                                ? Colors.black54
                                : Colors.black87,
                          ),
                        ),
                        if (!inboxItem.isRead)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.brightness_1,
                                color: Colors.red, size: 12),
                          ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Last message at ${inboxItem.lastMessageTime}',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
