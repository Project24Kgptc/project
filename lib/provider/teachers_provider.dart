import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

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

  Future<void> deleteStudent(String documentId, context) async {
    try {
      // Reference to your Firestore collection
      CollectionReference studentsCollection =
          FirebaseFirestore.instance.collection('teachers');

      // Delete the document with the specified documentId
      await studentsCollection.doc(documentId).delete();

      notifyListeners();

      print('teacher deleted successfully');
      showSnackBar(
          context: context,
          message: 'Teacher Deleted',
          icon: Icon(Icons.check_box));
    } catch (e) {
      print('teacher deleting student: $e');
    }
  }
}
