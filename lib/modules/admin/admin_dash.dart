// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/modules/admin/students/students.dart';
import 'package:student_analytics/modules/admin/teachers/teachers.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/provider/batch_provider.dart';
import 'package:student_analytics/provider/students_provider.dart';
import 'package:student_analytics/provider/teachers_provider.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

ValueNotifier buttonLoadingNotifier = ValueNotifier(false);

class AdminDashboard extends StatelessWidget {
	const AdminDashboard({super.key, required this.adminName});

	final String adminName;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(adminName),
				actions: [
					IconButton(
						onPressed: () async {
							try {
								await FirebaseAuth.instance.signOut();
								Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => LoginPage()));
							}
							catch(err) {
								showSnackBar(
									context: context, 
									message: '  Error occured !', 
									icon: const Icon(Icons.error_sharp, color: Colors.red,), 
									duration: 3
								);
							}
						},
						icon: const Icon(Icons.logout),
					)
				],
			),
			body: SafeArea(
				child: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						children: [
							ElevatedButton(
								onPressed: () => navigateToStudentsPage(context),
								child: const Text('Students'),
							),
							ElevatedButton(
								onPressed: () => navigateToTeachersPage(context),
								child: const Text('Teachers'),
							),
						],
					),
				),
			),
		);
	}

	Future<void> navigateToStudentsPage(BuildContext context) async {
		Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AdminAllStudentsPage()));
		final students = await FirebaseFirestore.instance.collection('students').get();
		await Future.delayed(const Duration(microseconds: 100));
		final List<StudentModel> studentObjectsList = students.docs.map((student) => StudentModel.fromMaptoObject(student.data())).toList();

		List<String> batchList = [];
		for (var student in studentObjectsList) {
			if(!batchList.contains(student.batch)) {
				batchList.add(student.batch);
			}
		}
		batchList.sort();

		Provider.of<StudentsProvider>(context, listen: false).setAllStudentsData(studentObjectsList);
		dropdownNotifier.value = '--- All ---';
		Provider.of<StudentsBatchProvider>(context, listen: false).setBatches(batchList);
	}

	Future<void> navigateToTeachersPage(BuildContext context) async {
		Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AdminAllTeachersPage()));
		final teachers = await FirebaseFirestore.instance.collection('teachers').get();
		await Future.delayed(const Duration(microseconds: 100));
		final List<TeacherModel> teacherObjectsList = teachers.docs.map((student) => TeacherModel.fromMaptoObject(student.data())).toList();
		Provider.of<TeachersProvider>(context, listen: false).setAllTeachersData(teacherObjectsList);
	}
}