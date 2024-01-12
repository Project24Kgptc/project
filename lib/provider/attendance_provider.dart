import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
	List<AttendanceModel> _attendances = [];

	List<AttendanceModel> get attendances => _attendances;

	void addAttendance(List<AttendanceModel> attendances) {
		_attendances = attendances;
		notifyListeners();
	}
}