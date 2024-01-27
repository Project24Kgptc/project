import 'package:flutter/material.dart';

void showSnackBar({
	int duration = 2,
	required BuildContext context, 
	required String message, 
	required Widget icon, 
}) {
	ScaffoldMessenger.of(context).showSnackBar(SnackBar(
		behavior: SnackBarBehavior.floating,
		margin: const EdgeInsets.only(
			left: 40,
			right: 40,
			bottom: 50
		),
		duration: Duration(seconds: duration),
		content: Row(
			children: [
				icon,
				Text(message),
			],
		)
	));
}