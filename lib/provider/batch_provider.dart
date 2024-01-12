import 'package:flutter/material.dart';

class StudentsBatchProvider extends ChangeNotifier {

	List<DropdownMenuItem<String>> _batches = [
		const DropdownMenuItem<String>(
			value: '--- All ---',
			child: Text('--- All ---'),
		)
	];
	List<DropdownMenuItem<String>> get batches => _batches;

	void setBatches(List<String> batchesList) {
		_batches = [
			const DropdownMenuItem<String>(
				alignment: Alignment.center,
				value: '--- All ---',
				child: Text(
					'--- All ---',
					textAlign: TextAlign.center,
					style: TextStyle(
						color: Colors.white,
						fontWeight: FontWeight.w600
					),
				),
			),
			...batchesList.map((batch) {
				return DropdownMenuItem<String>(
					value: batch,
					child: Text(
						batch,
						style: const TextStyle(
							color: Colors.white,
							fontWeight: FontWeight.w600
						),
					),
				);
			}),
		];
		notifyListeners();
	}
}