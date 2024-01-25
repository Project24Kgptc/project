// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/admin/students/add_student/student_validator.dart';
import 'package:student_analytics/provider/students_provider.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import '../../../../widgets/alert_dialog.dart';
import '../../../../widgets/text_field.dart';

ValueNotifier<bool> addStudentButtonLoadingNotifier = ValueNotifier(false);

TextEditingController nameController = TextEditingController();
TextEditingController regNoController = TextEditingController();
TextEditingController rollNoController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController batchController = TextEditingController();

class AddStudent extends StatelessWidget {
	AddStudent({super.key});

	final GlobalKey<FormState> _addStudentFormkey = GlobalKey<FormState>();
	final StudentValidator _validator = StudentValidator();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.deepPurpleAccent,
				title: const Text('Add Student'),
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
							key: _addStudentFormkey,
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									const Text(
										"Add Student",
										style: TextStyle(
											fontSize: 28,
											fontWeight: FontWeight.w800,
										),
									),
									const SizedBox(height: 20,),
									CustomTextField(
										labelText: 'Name', 
										prefixIcon: Icons.person, 
										controller: nameController, 
										validator: _validator.name,
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Register Number', 
										prefixIcon: Icons.numbers, 
										controller: regNoController, 
										keyboardType: TextInputType.number,
										validator: _validator.registerNumber,
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Roll Number', 
										prefixIcon: Icons.numbers, 
										controller: rollNoController, 
										keyboardType: TextInputType.number,
										validator: _validator.rollNumber,
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Email', 
										prefixIcon: Icons.email, 
										controller: emailController, 
										keyboardType: TextInputType.emailAddress,
										validator: _validator.email,
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Phone Number', 
										prefixIcon: Icons.phone, 
										controller: phoneNumberController, 
										keyboardType: TextInputType.number,
										validator: _validator.phoneNumber,
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Batch', 
										hintText: '2021-24',
										prefixIcon: Icons.people, 
										controller: batchController, 
										keyboardType: TextInputType.number,
										validator: _validator.batch,
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
											onPressed: () => addStudent(context),
											child: ValueListenableBuilder(
												valueListenable: addStudentButtonLoadingNotifier,
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

	Future<void> addStudent(BuildContext context) async {
		if(_addStudentFormkey.currentState!.validate()) {
			addStudentButtonLoadingNotifier.value = true;
			final StudentModel student = StudentModel(
				name: nameController.text.trim(),
				email: emailController.text.trim(),
				regNo: regNoController.text.trim(),
				rollNo: rollNoController.text.trim(),
				phoneNumber: phoneNumberController.text.trim(),
				batch: batchController.text.trim(),
				subjects: [],
				rank: '1',
			);
			final studentData = student.toMap();
			try {
				final isExisting = await FirebaseFirestore.instance.collection('students').doc(student.regNo).get();
				if(isExisting.exists) {
					// customAlertDialog(
					// 	context: context,
					// 	messageText: "Student with Register Number ${student.regNo} already exists. Click 'SAVE' to replace exisiting data",
					// 	onPrimaryButtonClick: () async {
					// 		await FirebaseFirestore.instance.collection('students').doc(student.regNo).set(studentData);
					// 		showSnackBar(
					// 			context: context, 
					// 			message: '  Student updated', 
					// 			icon: const Icon(Icons.update, color: Colors.green,), 
					// 			duration: 2
					// 		);
					// 		Provider.of<StudentsProvider>(context, listen: false).addStudent(student);
					// 		_addStudentFormkey.currentState!.reset();
					// 		addUserAuth(student.email);
					// 		Navigator.of(context).pop();
					// 	},
					// );
					customAlertDialog(
						context: context,
						messageText: "Student with Register Number ${student.regNo} already exists !",
						onPrimaryButtonClick: () => Navigator.of(context).pop(),
						primaryButtonText: 'Back',
						isSecondButtonVisible: false
					);
				}
				else {
					await FirebaseFirestore.instance.collection('students').doc(student.regNo).set(studentData);
					showSnackBar(
						context: context, 
						message: '  Student added', 
						icon: const Icon(Icons.done_outline, color: Colors.green,), 
						duration: 2
					);
					Provider.of<StudentsProvider>(context, listen: false).addStudent(student);
					_addStudentFormkey.currentState!.reset();

					addUserAuth(student.email);
				}
			}
			catch(err) {
				sss(err);
				showSnackBar(
					context: context, 
					message: '  Operation failed! try again', 
					icon: const Icon(Icons.feedback, color: Colors.red,), 
					duration: 2
				);
			}
			finally {
				addStudentButtonLoadingNotifier.value = false;
			}
		}
	}

	Future<void> addUserAuth(String email) async {
		final auth = FirebaseAuth.instance;
		await auth.createUserWithEmailAndPassword(
			email: email,
			password: '111111'
		);
		await FirebaseAuth.instance.signOut();
	}
}