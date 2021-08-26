import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/firestore_helper.dart';
import 'package:gsg2_firebase/Auth/providers/auth_provider.dart';
import 'package:gsg2_firebase/chats/profile_page.dart';
import 'package:provider/provider.dart';

class UpdateProgile extends StatefulWidget {
  static final routeName = 'updateprofile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UpdateProgile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Editing Profile Page'),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .updateProfile();
              },
              icon: Icon(Icons.done),
            )
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (context, provider, x) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.captureUpdateProfileImage();
                    },
                    child: provider.updatedFile == null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                NetworkImage(provider.user.imageUrl),
                          )
                        : CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(provider.updatedFile),
                          ),
                  ),
                  ItemWidget('first Name', provider.firstNameController),
                  ItemWidget('last Name', provider.lastNameController),
                  ItemWidget('country Name', provider.countryController),
                  ItemWidget('city Name', provider.cituController),
                ],
              ),
            );
          },
        ));
  }
}

class ItemWidget extends StatelessWidget {
  String label;
  TextEditingController valueController;
  ItemWidget(this.label, this.valueController);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(
              controller: valueController,
              style: TextStyle(fontSize: 22),
            ),
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
