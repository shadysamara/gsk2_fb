import 'package:flutter/material.dart';
import 'package:gsg2_firebase/services/routes_helper.dart';

class CustomDialoug {
  CustomDialoug._();
  static CustomDialoug customDialoug = CustomDialoug._();
  showCustomDialoug(String message, [Function function]) {
    showDialog(
        context: RouteHelper.routeHelper.navKey.currentContext,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    if (function == null) {
                      RouteHelper.routeHelper.back();
                    } else {
                      function();
                      RouteHelper.routeHelper.back();
                    }
                  },
                  child: Text('ok'))
            ],
          );
        });
  }
}
