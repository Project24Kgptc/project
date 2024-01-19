// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import 'package:student_analytics/widgets/text_field.dart';

ValueNotifier<bool> addSubjectButtonNotifier = ValueNotifier(false);
TextEditingController courseCodeController = TextEditingController();
TextEditingController courseNameController = TextEditingController();
TextEditingController semesterController = TextEditingController();


class AddSubject extends StatelessWidget {
	AddSubject({super.key, required this.teacherName, required this.teacherId});

	final String teacherName;
	final String teacherId;

	final GlobalKey<FormState> _addSubjectFormkey = GlobalKey<FormState>();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.deepPurpleAccent,
				title: const Text('Add Subject'),
			),
			backgroundColor: Colors.deepPurpleAccent,
			body: SafeArea(
				child: Center(
					child: SingleChildScrollView(
						child: Container(
							padding: const EdgeInsets.all(20),
							margin: const EdgeInsets.all(10),
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(20)
							),
							child: Form(
								key: _addSubjectFormkey,
								child: Column(
									mainAxisSize: MainAxisSize.min,
									children: [
										const Text(
											"Add Subject",
											style: TextStyle(
												fontSize: 28,
												fontWeight: FontWeight.w800,
											),
										),
										const SizedBox(height: 20,),
										CustomTextField(
											labelText: 'Course code', 
											prefixIcon: Icons.numbers, 
											keyboardType: TextInputType.number,
											controller: courseCodeController, 
											validator: (input) {
												final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
												if(input!.trim() == '') {
													return 'Id is required';
												}
												else if(!numberCheckRegex.hasMatch(input)) {
													return 'Invalid Id';
												}
												return null;
											},
										),
										const SizedBox(height: 10,),
										CustomTextField(
											labelText: 'Course name', 
											prefixIcon: Icons.insert_drive_file, 
											controller: courseNameController, 
											validator: (input) {
												if(input!.trim() == '') {
													return 'Name is required';
												}
												return null;
											},
										),
										const SizedBox(height: 10,),
										CustomTextField(
											labelText: 'Semester', 
											prefixIcon: Icons.email, 
											controller: semesterController, 
											keyboardType: TextInputType.none,
											validator: (input) {
												if(input!.trim() == '') {
													return 'Name is required';
												}
												return null;
											},
										),
										const SizedBox(height: 20,),
										Container(
											height: 48,
											decoration: BoxDecoration(
												borderRadius: BorderRadius.circular(70)
											),
											width: double.infinity,
											child: ElevatedButton(
												style: ElevatedButton.styleFrom(
													backgroundColor: Colors.deepPurpleAccent,
													shape: RoundedRectangleBorder(
														borderRadius: BorderRadius.circular(30),
													)
												),
												onPressed: () {
													// addSubjecttofirebase(context);
													// addSubject(context);
												},
												child: ValueListenableBuilder(
													valueListenable: addSubjectButtonNotifier,
													builder: (context, value, child) {
														if(value) {
															return const SizedBox(
																height: 22,
																width: 22,
																child: CircularProgressIndicator(
																	color: Colors.white,
																	strokeWidth: 3,
																),
															);
														}
														else {
															return const Text(
																'Add',
																style: TextStyle(
																	fontSize: 19,
																	fontWeight: FontWeight.w900
																)
															);
														}
													},
                          
												)
											),
										),
										const SizedBox(height: 10,)
									],
								),
							),
						),
					)
				)
			),
		);
	}

	void addSubject(BuildContext context) async {
		addSubjectButtonNotifier.value = true;
		await Future.delayed(const Duration(seconds: 2));
		addSubjectButtonNotifier.value = false;
	}

	// Future<void> addSubjecttofirebase(BuildContext context) async {
 
	// 	if(_addSubjectFormkey.currentState!.validate()) {
     
	// 	// 	try {
	// 	// 		final isExisting = await FirebaseFirestore.instance.collection('students').doc(student.regNo).get();
	// 	// 		if(isExisting.exists) {
	// 	// 			//showTheAlertDialog(context, regNoController.text.trim());
	// 	// 		}
	// 	// 		else {
	// 	// 			await FirebaseFirestore.instance.collection('students').doc(student.regNo).set(studentData);
	// 	// 			showSnackBar(
	// 	// 				context: context, 
	// 	// 				message: '  Student added', 
	// 	// 				icon: const Icon(Icons.done_outline, color: Colors.green,), 
	// 	// 				duration: 2
	// 	// 			);
	// 	// 			Provider.of<StudentsProvider>(context, listen: false).addTeacher(student);
	// 	// 			_addTeacherFormkey.currentState!.reset();

	// 	// 			// addUserAuth(student.email);
	// 	// 		}
	// 	// 	}
	// 	// 	catch(err) {
	// 	// 		sss(err);
	// 	// 		showSnackBar(
	// 	// 			context: context, 
	// 	// 			message: '  Operation failed! try again', 
	// 	// 			icon: const Icon(Icons.feedback, color: Colors.red,), 
	// 	// 			duration: 2
	// 	// 		);
	// 	// 	}
	// 	// 	finally {
	// 	// 		addTeacherButtonLoadingNotifier.value = false;
	// 	// 	}
			
	// 		addSubjectButtonNotifier.value = true;
	// 		 final SubjectModel subjectModel =SubjectModel(subjectId:teacherId , teacherName: teacherName, courseCode: courseCodeController.text.trim(), semester: semesterController.text.trim(), subjectName: courseNameController.text.trim());
    //   // TeacherModel(
	// 		// 	teacherId: teacherIdController.text.trim(),
	// 		// 	name: nameController.text.trim(),
	// 		// 	email: emailController.text.trim(),
	// 		// 	phoneNumber: phoneNumberController.text.trim()
	// 		// );
	// 		final subjectData = subjectModel.toMap();
	// 		try {
	// 			final subjExists = await FirebaseFirestore.instance.collection('subjects').doc(subjectModel.subjectName).get();
	// 			if(subjExists.exists) {
	// 				showTheAlertDialog(context, subjectModel.subjectName, subjectModel);
	// 			}
	// 			else {
	// 				await FirebaseFirestore.instance.collection('subjects').doc().set(subjectData);
	// 				showSnackBar(
	// 					context: context, 
	// 					message: '  Teacher added', 
	// 					icon: const Icon(Icons.done_outline, color: Colors.green,), 
	// 					duration: 2
	// 				);
	// 				Provider.of<SubjectProvider>(context, listen: false).AddSubject(subjectModel);
	// 				_addSubjectFormkey.currentState!.reset();

				
	// 			}
	// 		}
	// 		catch(err) {
	// 			sss(err);
	// 			showSnackBar(
	// 				context: context, 
	// 				message: '  Operation failed! try again', 
	// 				icon: const Icon(Icons.feedback, color: Colors.red,), 
	// 				duration: 2
	// 			);
	// 		}
	// 		finally {
	// 			addSubjectButtonNotifier.value = false;
	// 		}
	// 	}
	// }

	// Future<void> showTheAlertDialog(BuildContext context, String email, SubjectModel subjectModel) {
	// 	return showDialog(
	// 		context: context, 
	// 		builder: (context) {
	// 			return AlertDialog(
	// 				icon: const Icon(Icons.info),
	// 				content: ConstrainedBox(
	// 					constraints: const BoxConstraints(
	// 						maxWidth: 200
	// 					),
	// 					child: Text(
	// 						"Teacher with email $email already exists. Click 'SAVE' to replace exisiting data",
	// 						textAlign: TextAlign.center,
	// 					),
	// 				),
	// 				actionsAlignment: MainAxisAlignment.spaceAround,
	// 				actions: [
	// 					ElevatedButton(
	// 						onPressed: () async {
	// 							await FirebaseFirestore.instance.collection('teachers').doc().set(subjectModel.toMap());
	// 							showSnackBar(
	// 								context: context, 
	// 								message: '  Subject added', 
	// 								icon: const Icon(Icons.done_outline, color: Colors.green,), 
	// 								duration: 2
	// 							);
	// 							Provider.of<SubjectProvider>(context, listen: false).AddSubject(subjectModel);
	// 							_addSubjectFormkey.currentState!.reset();

							
	// 						},
	// 						child: const Text('Save')
	// 					),
	// 					ElevatedButton(
	// 						onPressed: () {
	// 							Navigator.pop(context);
	// 						},
	// 						child: const Text('Discard')
	// 					),
	// 				],
	// 			);
	// 		}
	// 	);
	// }

  
}

// Future<void>addSubject(){

//   try {
    
//   } catch (e) {
  
//   }
  
// }