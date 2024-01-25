// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/modules/student/subject_dash.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class StudentDashboard extends StatelessWidget {
	StudentDashboard({super.key, required this.studentData});

	final StudentModel studentData;

	final List<String> subjects = [
		'Internet Of Things',
		'Indian constitution',
		'Smart Device Programming',
		'Entreprenuership and Startup',
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Student Dashboard'),
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
							width: double.infinity,
							margin: const EdgeInsets.all(10),
							decoration: const BoxDecoration(
								color: Colors.white,
								boxShadow: [
									BoxShadow(
										blurRadius: 2,
										spreadRadius: 0,
										offset: Offset(-2, 2)
									)
								]
							),
							child: ListTile(
								contentPadding: const EdgeInsets.symmetric(horizontal: 10),
								leading: const CircleAvatar(
									radius: 25,
									backgroundColor: Colors.deepPurpleAccent,
									child: Icon(Icons.person, size: 35,),
								),
								title: Text(
									studentData.name,
									style: const TextStyle(
										fontSize: 17,
										fontWeight: FontWeight.w900
									),
								),
								subtitle: Text(
									studentData.regNo,
									style: const TextStyle(
										fontSize: 12,
										fontWeight: FontWeight.w600
									),
								),
								trailing: const Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Text(
											'Rank',
											style: TextStyle(
												fontSize: 12,
												fontWeight: FontWeight.w600
											),
										),
										CircleAvatar(
											radius: 13,
											backgroundColor: Colors.black,
											child: Text(
												'65',
												style: TextStyle(
													color: Colors.white,
													fontSize: 12,
													fontWeight: FontWeight.w600
												),
										),
										)
									],
								),
							),
						),
						const SizedBox(height: 20,),
						const Stack(
							alignment: Alignment.center,
							children: [
								SizedBox(
									height: 150,
									width: 150,
									child: CircularProgressIndicator(
										strokeWidth: 8,
										color: Colors.deepPurpleAccent,
										backgroundColor: Colors.grey,
										value: 0.75,
									),
								),
								Text(
									'${0.75*100}%',
									style: TextStyle(
										fontSize: 25,
										fontWeight: FontWeight.w900
									),
								)
							],
						),
						const SizedBox(height: 40,),
						Container(
							width: double.infinity,
							margin: const EdgeInsets.symmetric(horizontal: 5),
							padding: const EdgeInsets.all(12),
							decoration: BoxDecoration(
								color: Colors.purple,
								borderRadius: BorderRadius.circular(5)
							),
							child: const Text(
								'Subjects',
								style: TextStyle(
									color: Colors.white,
									fontWeight: FontWeight.w600,
									fontSize: 17
								),
							),
						),
						const SizedBox(height: 5,),
						Expanded(
							child: ListView.separated(
								itemBuilder: (context, index) {
									return Container(
										margin: const EdgeInsets.symmetric(horizontal: 10),
										padding: const EdgeInsets.all(10),
										decoration: BoxDecoration(
											color: Colors.deepPurpleAccent,
											borderRadius: BorderRadius.circular(5)
										),
										child: ListTile(
											onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubjectDashboard(),)),
											title: Text(
												subjects[index],
												style: const TextStyle(
													color: Colors.black,
													fontWeight: FontWeight.w600,
													fontSize: 16
												),
											),
										)
									);
								},
								separatorBuilder: (context, index) => const SizedBox(height: 3,),
								itemCount: subjects.length,
							),
						)
					],
				), 
			),
		);
	}
}