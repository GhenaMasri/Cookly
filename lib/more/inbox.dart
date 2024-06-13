import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/more/chat.dart';

class InboxPage extends StatelessWidget {
  final List<InboxItem> inboxItems = [
    InboxItem(senderName: 'Alice', lastMessageTime: '2:30 PM', isRead: false),
    InboxItem(senderName: 'Bob', lastMessageTime: '1:15 PM', isRead: true),
    InboxItem(senderName: 'Charlie', lastMessageTime: '12:45 PM', isRead: false),
    InboxItem(senderName: 'Dave', lastMessageTime: '11:30 AM', isRead: true),
    InboxItem(senderName: 'Eve', lastMessageTime: '10:00 AM', isRead: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: TColor.white,
      appBar: AppBar(
         backgroundColor: TColor.white,
        title: Text('Inbox' , style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
      ),
      body: ListView.builder(
        itemCount: inboxItems.length,
        itemBuilder: (context, index) {
          return InboxItemWidget(inboxItem: inboxItems[index]);
        },
      ),
    );
  }
}

class InboxItem {
  final String senderName;
  final String lastMessageTime;
  final bool isRead;

  InboxItem({required this.senderName, required this.lastMessageTime, required this.isRead});
}

class InboxItemWidget extends StatelessWidget {
  final InboxItem inboxItem;

  InboxItemWidget({required this.inboxItem});

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
          pushReplacementWithAnimation(context, ChatPage());
           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage()));
          print('Tapped on ${inboxItem.senderName}');
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: inboxItem.isRead ? Colors.grey : TColor.primary,
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
                            fontWeight: inboxItem.isRead ? FontWeight.normal : FontWeight.bold,
                            color: inboxItem.isRead ? Colors.black54 : Colors.black87,
                          ),
                        ),
                        if (!inboxItem.isRead)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.brightness_1, color: Colors.red, size: 12),
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
  }}