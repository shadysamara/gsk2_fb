import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/firestore_helper.dart';
import 'package:gsg2_firebase/chats/profile_page.dart';
import 'package:gsg2_firebase/chats/users_page.dart';

class HomePage extends StatelessWidget {
  static final routeName = 'home';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child:
            Scaffold(body: TabBarView(children: [UsersPage(), ProfilePage()])));
  }
}
