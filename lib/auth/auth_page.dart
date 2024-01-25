// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/modules/admin/admin_dash.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/provider/subject_provider.dart';
import 'package:student_analytics/modules/student/std_dash.dart';
import 'package:student_analytics/modules/teacher/teacher_dash.dart';

class AuthScreen extends StatelessWidget {
	AuthScreen({super.key});

	final FirebaseAuth auth = FirebaseAuth.instance;

	@override
	Widget build(BuildContext context) {
		checkAuth(context);
		return const Scaffold(
			backgroundColor: Colors.deepPurpleAccent,
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
		await Future.delayed(const Duration(seconds: 1));
		final User? user = auth.currentUser;
		
		if(user == null) {
			Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginPage()));
		}
		else {
			final studentData = await FirebaseFirestore.instance.collection('students').doc(user.email!.replaceAll('@mail.com', '')).get();
			if(studentData.exists) {
				final StudentModel studentModel = StudentModel.fromMaptoObject(studentData.data()!);
				Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => StudentDashboard(studentData: studentModel)));
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
				Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => AdminDashboard(adminName: adminData.data()!['name'])));
				return;
			}
			Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginPage()));
		}
	}
}