import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplachScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then((value) =>
        Provider.of<AuthProvider>(context, listen: false).checkLogin());
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('Splach Screen'),
      ),
    );
  }
}
