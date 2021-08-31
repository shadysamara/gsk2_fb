import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/firestore_helper.dart';
import 'package:gsg2_firebase/Auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

class ChatPage extends StatelessWidget {
  static final String routeName = 'chatPage';
  TextEditingController textEditingController = TextEditingController();
  String message;
  sendToFirestore() async {
    textEditingController.clear();
    FirestoreHelper.firestoreHelper.addMessageToFirestore(
        {'message': this.message, 'dateTime': DateTime.now()});
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, x) {
          return Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream:
                          FirestoreHelper.firestoreHelper.getFirestoreStream(),
                      builder: (context, datasnapshot) {
                        Future.delayed(Duration(seconds: 1)).then((value) {
                          scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeInOut);
                        });
                        QuerySnapshot<Map<String, dynamic>> querySnapshot =
                            datasnapshot.data;
                        List<Map> messages =
                            querySnapshot.docs.map((e) => e.data()).toList();
                        return ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              bool isMe = messages[index]['userId'] ==
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .myId;
                              return isMe
                                  ? Container(
                                      child: ChatBubble(
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(top: 20),
                                        backGroundColor: Colors.blue,
                                        child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            child: messages[index]
                                                        ['imageUrl'] ==
                                                    null
                                                ? Text(
                                                    messages[index]['message'],
                                                    style: TextStyle(
                                                        color: Colors.white))
                                                : Image.network(messages[index]
                                                    ['imageUrl'])),
                                        clipper: ChatBubbleClipper5(
                                            type: BubbleType.sendBubble),
                                      ),
                                    )
                                  : ChatBubble(
                                      backGroundColor: Color(0xffE7E7ED),
                                      margin: EdgeInsets.only(top: 20),
                                      child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          child: messages[index]['imageUrl'] ==
                                                  null
                                              ? Text(
                                                  messages[index]['message'],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              : Image.network(
                                                  messages[index]['imageUrl'])),
                                      clipper: ChatBubbleClipper5(
                                          type: BubbleType.receiverBubble),
                                    );
                            });
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    provider.sendImageToChat();
                                  },
                                  icon: Icon(Icons.attach_file)),
                              Expanded(
                                  child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                                controller: textEditingController,
                                onChanged: (x) {
                                  this.message = x;
                                },
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
                          child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                sendToFirestore();
                              }))
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
