import 'package:flutter/material.dart';

void showSnackBar({
	required BuildContext context, 
	required String message, 
	required Widget icon, 
	required int duration
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