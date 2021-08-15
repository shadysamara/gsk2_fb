import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  String label;
  TextEditingController controller;
  CustomTextfield(this.label, this.controller);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: this.controller,
        decoration: InputDecoration(
            labelText: this.label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
