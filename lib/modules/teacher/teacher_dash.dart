// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/teacher/subject/subject_dash.dart';
import 'package:student_analytics/provider/subject_provider.dart';
import 'package:student_analytics/modules/teacher/add_subject/add_subject.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class TeacherDashboard extends StatelessWidget {
	const TeacherDashboard({super.key, required this.teacherData});

	final TeacherModel teacherData;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			floatingActionButton: ElevatedButton(
				style: ElevatedButton.styleFrom(
					backgroundColor:  const Color(0xFFA95DE7)
				),
				onPressed: () async {
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
					Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddSubject(teacherId: teacherData.teacherId, teacherName: teacherData.name, batchesList: batchList,)));
				},
				child: const Text('Add Subject'),
			),
			appBar: AppBar(
				title: const Text('Teacher Dashboard'),
				backgroundColor:  const Color(0xFFA95DE7),
				actions: [
					IconButton(
						onPressed: () async {
							try {
								await FirebaseAuth.instance.signOut();
								Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginPage()));
							}
							catch(err) {
								sss(err);
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
				child: Container(
					height: double.infinity,
					width: double.infinity,
					decoration: const BoxDecoration(
						image: DecorationImage(
							image: AssetImage('assets/background_images/bg.jpeg'),
							fit: BoxFit.cover
						),
						
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Container(
								padding: const EdgeInsets.all(5),
								margin: const EdgeInsets.all(15),
								width: double.infinity,
								decoration: BoxDecoration(
									color:  const Color(0xFFA95DE7),
									borderRadius: BorderRadius.circular(30)
								),
								child: ListTile(
									title: Text(
										teacherData.name,
										style: const TextStyle(
											color: Colors.white,
											fontWeight: FontWeight.w500
										),
									),
									subtitle: Text(
										teacherData.email,
										style: const TextStyle(
											color: Colors.white
										),
									),
								),
							),
							Container(
								width: double.infinity,
								margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
								padding: const EdgeInsets.all(10),
								decoration: BoxDecoration(
									color: Colors.white,
									borderRadius: BorderRadius.circular(10)
								),
								child: const Text(
									'Subjects',
									textAlign: TextAlign.center,
									style: TextStyle(
										fontSize: 20,
									),
								),
							),
							Expanded(
								child: Consumer<SubjectProvider>(
									builder: (context, model, child) {
										if(model.isLoading) {
											return const Center(
												child: CircularProgressIndicator(
													color: Colors.white,
												),
											);
										}
										else if(model.subjects.isEmpty) {
											return const Center(
												child: Text('No data available'),
											);
										}
										else {
											return ListView.builder(
												itemBuilder: (context, index) {
													return Padding(
														padding: const EdgeInsets.only(top: 3, left: 3, right: 3),
														child: Container(
															margin: const EdgeInsets.symmetric(horizontal: 20),
															decoration: BoxDecoration(
																color:  Color(0xFFA95DE7),
																borderRadius: BorderRadius.circular(10)
															),
															child: ListTile(
																contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
																leading: const Icon(Icons.subject, color: Colors.white,),
																title: Text(
																	model.subjects[index].subjectName,
																	style: const TextStyle(
																		fontWeight: FontWeight.w500,
																		color: Colors.white
																	),
																),
																subtitle: Text(
																	model.subjects[index].batch,
																	style: TextStyle(
																		color: Colors.white
																	),
																),
																trailing: Text(
																	model.subjects[index].courseCode,
																	style: TextStyle(
																		color: Colors.white
																	),
																),
																onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => TeacherSubjectDashboard(subjectModel: model.subjects[index]))),
															),
														),
													);
												},
												itemCount: model.subjects.length,
											);
										} 
									},
								),
							)
						],
					),
				),
			),
		);
	}
}