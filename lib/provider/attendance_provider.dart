import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/attendance_model.dart';
import 'package:student_analytics/data_models/student_model.dart';

import '../widgets/snack_bar.dart';

class AttendanceProvider extends ChangeNotifier {
	List<AttendanceModel> _attendances = [];

	List<AttendanceModel> get attendances => _attendances;

	void addAttendance(List<AttendanceModel> attendances) {
		_attendances = attendances;
		notifyListeners();
	}

	//get students by batch
  Future<List<StudentModel>> getStudentsbyBatch(
    batch,
  ) async {
    List<StudentModel> students = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('batch', isEqualTo: batch)
          .get();

      students = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return StudentModel(
            name: data['name'],
            email: data['email'],
            regNo: data['regNo'],
            rollNo: data['rollNo'],
            phoneNumber: data['phoneNumber'],
            batch: data['batch'],
            rank: data['rank'],
            subjects: ['you can change'],
            );
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error retrieving students: $e');
    }
    notifyListeners();
    return students;
  }

//add attentence 
Future<void> addAttentence(AttendanceModel attentenceData, context) async {
    try {
      // Reference to the 'subjectRooms' collection
      CollectionReference subjectRoomsCollection =
          FirebaseFirestore.instance.collection('attentence');
      AttendanceModel data = attentenceData;
      // Add a new document to the 'subjectRooms' collection
      await subjectRoomsCollection
          .doc(attentenceData.date + attentenceData.hour)
          .set(data.toMap());

      print('attentence added successfully');
      showSnackBar(
          context: context,
          message: 'attentence added successfully',
          icon: Icon(
            Icons.check,
            color: Colors.green,
          ),
          duration: 2);
    } catch (e) {
      print('Error adding attentence: $e');
    }
  }
}