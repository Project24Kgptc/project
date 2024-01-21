import 'package:flutter/material.dart';

Future<void> customAlertDialog({
	required BuildContext context,
	required String messageText,
	String primaryButtonText = '  Save  ',
	required void Function() onPrimaryButtonClick,
	bool isSecondButtonVisible = true,
	String secondButtonText = 'Discard',
	void Function()? onSecondaryButtonClick,
}) {
	return showDialog(
		context: context, 
		builder: (context) {
			return AlertDialog(
				icon: const Icon(Icons.warning_outlined),
				content: ConstrainedBox(
					constraints: const BoxConstraints(
						maxWidth: 200
					),
					child: Text(
						messageText,
						textAlign: TextAlign.center,
					),
				),
				actionsAlignment: MainAxisAlignment.spaceAround,
				actionsPadding: const EdgeInsets.only(bottom: 20),
				actions: isSecondButtonVisible ? [
					ElevatedButton(
						onPressed: () => onSecondaryButtonClick ?? Navigator.of(context).pop(),
						style: ElevatedButton.styleFrom(
							backgroundColor: Colors.black
						),
						child: Text(secondButtonText)
					),
					ElevatedButton(
						onPressed: onPrimaryButtonClick, 
						style: ElevatedButton.styleFrom(
							backgroundColor: Colors.black
						),
						child: Text(primaryButtonText)
					),
				] :  [
					ElevatedButton(
						onPressed: () => Navigator.of(context).pop(), 
						style: ElevatedButton.styleFrom(
							backgroundColor: Colors.black
						),
						child: Text(primaryButtonText)
					),
				],
			);
		}
	);
}