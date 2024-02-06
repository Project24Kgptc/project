import 'package:flutter/material.dart';

class AddMarkModel {
  final String rollNo;
  final String regNo;
  final String name;
  final TextEditingController markController;
  final FocusNode focusNode;

  AddMarkModel({
    required this.markController,
    required this.name,
    required this.rollNo,
    required this.regNo,
    required this.focusNode,
  });

  Map<String, dynamic> toMap() {
    return {
      'rollNo': rollNo,
      'regNo': regNo,
      'name': name,
      'mark': (markController.text == '') ? '0' : markController.text
    };
  }
}
