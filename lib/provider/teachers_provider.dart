import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/teacher_model.dart';

class TeachersProvider extends ChangeNotifier {
	
	bool _isLoading = true;
	bool get isLoading => _isLoading;

	List<TeacherModel> _teachers = [];
	List<TeacherModel> get teachers => _teachers;

	// void setLoading(bool value) {
	// 	_isLoading = value;
	// 	notifyListeners();
	// }

	void setAllTeachersData(List<TeacherModel> teachers) {
		_teachers = teachers;
		_isLoading = false;
		notifyListeners();
	}

	void addTeacher(TeacherModel student) {
		_teachers.add(student);
		notifyListeners();
	}

}