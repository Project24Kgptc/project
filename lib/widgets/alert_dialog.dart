import 'package:flutter/material.dart';

Future<void> customAlertDialog(BuildContext context) {
	return showDialog(
			context: context, 
			builder: (context) {
				return AlertDialog(
					title: const Text(
						"Are you sure ..?",
						textAlign: TextAlign.center,
					),
					actionsAlignment: MainAxisAlignment.spaceAround,
					actions: [
						IconButton(
							onPressed: () {
								Navigator.pop(context);
							},
							icon: const Icon(Icons.close)
						),
						IconButton(
							onPressed: () async {},
							icon: const Icon(Icons.check)
						)
					],
				);
			}
		);
}