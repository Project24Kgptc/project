// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/teacher/add_subject_old.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class TeacherDashboard extends StatelessWidget {
	const TeacherDashboard({super.key, required this.teacherData});

	final TeacherModel teacherData;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => TeacherAddSubject(teacherData: teacherData)));
				},
				child: const Icon(Icons.add),
			),
			appBar: AppBar(
				title: const Text('Teacher Dashboard'),
				actions: [
					IconButton(
						onPressed: () async {
							try {
								await FirebaseAuth.instance.signOut();
								Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginPage()));
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
				child: Column(
					children: [
						Container(
							padding: const EdgeInsets.all(5),
							margin: const EdgeInsets.all(5),
							width: double.infinity,
							decoration: const BoxDecoration(
								color: Colors.deepPurpleAccent,
							),
							child: ListTile(
								title: Text(teacherData.name),
								subtitle: Text(teacherData.email),
							),
						)
					],
				),
			),
		);
	}
}