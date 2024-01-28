import 'package:flutter/material.dart';

class SeriesTestMarkModel {

	final String rollNo;
	final String regNo;
	final String name;
	final TextEditingController markController;
	final FocusNode focusNode;

	SeriesTestMarkModel({
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