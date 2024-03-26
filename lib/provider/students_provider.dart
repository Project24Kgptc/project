import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class StudentsProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  List<StudentModel> _filteredStudents = [];
  List<StudentModel> get filteredStudents => _filteredStudents;

  // void setLoading(bool value) {
  // 	_isLoading = value;
  // 	notifyListeners();
  // }

  void setAllStudentsData(List<StudentModel> students) {
    _students = students;
    _filteredStudents = students;
    _isLoading = false;
    notifyListeners();
  }

  void addStudent(StudentModel student) {
    _students.add(student);
    notifyListeners();
  }

  void setFilteredStudent(String batch) {
    if (batch == '--- All ---') {
      _filteredStudents = _students;
    } else {
      _filteredStudents = _students.where((student) {
        return student.batch == batch;
      }).toList();
    }
    notifyListeners();
  }

  //delete student
  Future<void> deleteStudent(BuildContext context, String email) async {
    try {
      // Reference to your Firestore collection
      CollectionReference studentsCollection =
          FirebaseFirestore.instance.collection('students');

      // Delete the document with the specified documentId
      final url = Uri.parse('https://adacamease-server.onrender.com/delete');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'email': email});

      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          await studentsCollection.doc(email).delete();
          showSnackBar(
          context: context,
          message: 'Student deleted',
          icon: const Icon(Icons.check_box));
          _students.removeWhere((element) => element.email == email);
        } else {
          showSnackBar(
          context: context,
          message: 'Deletion failed',
          icon: const Icon(Icons.error, color: Colors.red,));
        }
      } catch (error) {
        showSnackBar(
          context: context,
          message: 'Error occured',
          icon: const Icon(Icons.error, color: Colors.red,));
      }

      notifyListeners();

      print('Student deleted successfully');
    } catch (e) {
      print('Error deleting student: $e');
    }
  }
}
