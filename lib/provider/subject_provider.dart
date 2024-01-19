import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/subject_model.dart';

class SubjectProvider extends ChangeNotifier {
	
	bool _isLoading = true;
	bool get isLoading => _isLoading;

	List<SubjectModel> subjects = [];
	List<SubjectModel> get subject => subjects;

	// void setLoading(bool value) {
	// 	_isLoading = value;
	// 	notifyListeners();
	// }

	void setAllTeachersData(List<SubjectModel> subject) {
		subjects = subject;
		_isLoading = false;
		notifyListeners();
	}

	void addSubject(SubjectModel sub) {
		subjects.add(sub);
		notifyListeners();
	}
}