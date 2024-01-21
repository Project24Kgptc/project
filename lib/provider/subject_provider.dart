import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/subject_model.dart';

class SubjectProvider extends ChangeNotifier {
	
	bool _isLoading = true;
	bool get isLoading => _isLoading;

	List<SubjectModel> _subjects = [];
	List<SubjectModel> get subjects => _subjects;

	// void setLoading(bool value) {
	// 	_isLoading = value;
	// 	notifyListeners();
	// }

	void setAllSubjectsData(List<SubjectModel> subject) {
		_subjects = subject;
		_isLoading = false;
		notifyListeners();
	}

	void addSubject(SubjectModel sub) {
		_subjects.add(sub);
		notifyListeners();
	}
}