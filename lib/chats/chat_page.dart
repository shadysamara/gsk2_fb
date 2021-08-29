import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/firestore_helper.dart';
import 'package:gsg2_firebase/Auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  static final String routeName = 'chatPage';
  String message;
  sendToFirestore() async {
    FirestoreHelper.firestoreHelper.addMessageToFirestore(
        {'message': this.message, 'dateTime': DateTime.now()});
  }

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
                        QuerySnapshot<Map<String, dynamic>> querySnapshot =
                            datasnapshot.data;
                        List<Map> messages =
                            querySnapshot.docs.map((e) => e.data()).toList();
                        return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return Text(messages[index]['message']);
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
                          child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onChanged: (x) {
                          this.message = x;
                        },
                      )),
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
