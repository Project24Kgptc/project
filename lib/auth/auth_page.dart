// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/admin_model.dart';
import 'package:student_analytics/data_models/attendance_model.dart';
import 'package:student_analytics/modules/admin/admin_dash.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/provider/subject_provider.dart';
import 'package:student_analytics/modules/student/std_dash.dart';
import 'package:student_analytics/modules/teacher/teacher_dash.dart';

import '../main.dart';

class AuthScreen extends StatelessWidget {
	AuthScreen({super.key});

	final FirebaseAuth auth = FirebaseAuth.instance;

	@override
	Widget build(BuildContext context) {
		checkAuth(context);
		return const Scaffold(
			backgroundColor: Color(0xFFA95DE7),
			body: SafeArea(
				child: Center(
					child: CircularProgressIndicator(
            color: Colors.white,
					),
				)
			),
		);
	}

	Future<void> checkAuth(BuildContext context) async {
		await Future.delayed(const Duration(seconds: 0));
		final User? user = auth.currentUser;
		
		if(user == null) {
			Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginPage()));
		}
		else {
			final studentData = await FirebaseFirestore.instance.collection('students').doc(user.email).get();
			if(studentData.exists) {
				final StudentModel studentModel = StudentModel.fromMaptoObject(studentData.data()!);
				List<SubjectModel>? subjects = await  getSubjects(studentModel);
				List<AttendanceModel> attentence = await getAllAttendance();
				Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => StudentDashboard(studentData: studentModel, subjects: subjects, attentencelist: attentence,)));
				return;
			}
			final teacherData = await FirebaseFirestore.instance.collection('teachers').doc(user.email!.replaceAll('@mail.com', '')).get();
			if(teacherData.exists) {
				final TeacherModel teacherModel = TeacherModel.fromMaptoObject(teacherData.data()!);
				Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => TeacherDashboard(teacherData: teacherModel)));
				
				final subjects = await FirebaseFirestore.instance.collection('subjects').where('teacherId', isEqualTo: teacherModel.teacherId).get();
				await Future.delayed(const Duration(microseconds: 100));
				final List<SubjectModel> subjectObjectsList = subjects.docs.map((subject) => SubjectModel.fromMaptoObject(subject.data())).toList();
				Provider.of<SubjectProvider>(context, listen: false).setAllSubjectsData(subjectObjectsList);
				return;
			}
			final adminData = await FirebaseFirestore.instance.collection('admins').doc(user.email!.replaceAll('@mail.com', '')).get();
			if(adminData.exists) {
				final AdminModel adminModel = AdminModel.fromMaptoObject(adminData.data()!);
				Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => AdminDashboard(adminModel: adminModel)));
				return;
			}
			Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginPage()));
		}
	}

    Future<List<SubjectModel>> getSubjects(StudentModel studentModel) async {
		try {
			final List<String> subjectIds = List<String>.from(studentModel.subjects);

			if (subjectIds.isNotEmpty) {
				final subjects = await FirebaseFirestore.instance
					.collection('subjects')
					.where('subjectId', whereIn: subjectIds)
					.get();

				final List<SubjectModel> subjectList = subjects.docs
					.map((e) => SubjectModel.fromMaptoObject(e.data()))
					.toList();

				return subjectList;
			}
			else {
				return [];
			}
		}
		catch (e) {
			sss('Error: $e');
			return [];
		}
	}


  	Future<List<AttendanceModel>> getAllAttendance() async {
		try {
			QuerySnapshot attendances = await FirebaseFirestore.instance.collection('attentence').get();

			List<AttendanceModel> attendance = attendances.docs.map((DocumentSnapshot document) => 
				AttendanceModel.fromMap(document.data() as Map<String, dynamic>)
			).toList();

			return attendance;
		}
		catch (e) {
			sss('error: $e');
			rethrow;
		}
	}
}