import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/firestore_helper.dart';
import 'package:gsg2_firebase/Auth/providers/auth_provider.dart';
import 'package:gsg2_firebase/chats/update_profile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static final routeName = 'profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getUserFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Profile Page'),
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false)
                      .fillControllers();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return UpdateProgile();
                  }));
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (context, provider, x) {
            return provider.user == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(provider.user.imageUrl),
                      ),
                      ItemWidget('Email', provider.user.email),
                      ItemWidget('first Name', provider.user.fName),
                      ItemWidget('last Name', provider.user.lName),
                      ItemWidget('country Name', provider.user.country),
                      ItemWidget('city Name', provider.user.city),
                    ],
                  );
          },
        ));
  }
}

class ItemWidget extends StatelessWidget {
  String label;
  String value;
  ItemWidget(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 22),
          )
        ],
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
    );
  }
}
