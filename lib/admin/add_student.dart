// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/provider/students_provider.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import '../widgets/text_field.dart';

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
										validator: (input) {
											if(input!.trim() == '') {
												return 'Name is required';
											}
											return null;
										},
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Register Number', 
										prefixIcon: Icons.numbers, 
										controller: regNoController, 
										keyboardType: TextInputType.number,
										validator: (input) {
											final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
											if(input!.trim() == '') {
												return 'Register number is required';
											}
											else if(input.trim().length != 4 || !numberCheckRegex.hasMatch(input)) {
												return 'Invalid Register number';
											}
											return null;
										},
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Roll Number', 
										prefixIcon: Icons.numbers, 
										controller: rollNoController, 
										keyboardType: TextInputType.number,
										validator: (input) {
											final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
											if(input!.trim() == '') {
												return 'Roll number is required';
											}
											else if(!numberCheckRegex.hasMatch(input)) {
												return 'Invalid roll number';
											}
											return null;
										},
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Email', 
										prefixIcon: Icons.email, 
										controller: emailController, 
										keyboardType: TextInputType.emailAddress,
										validator: (input) {
											final RegExp emailRegExp = RegExp( r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
											if(input!.trim() == '') {
												return "Email is required";
											}
											else if(!emailRegExp.hasMatch(input.trim())) {
												return 'Invalid email address';
											}
											return null;
										},
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Phone Number', 
										prefixIcon: Icons.phone, 
										controller: phoneNumberController, 
										keyboardType: TextInputType.number,
										validator: (input) {
											if(input!.trim() == '') {
												return 'Phone number is required';
											}
											return null;
										},
									),
									const SizedBox(height: 10,),
									CustomTextField(
										labelText: 'Batch', 
										hintText: '2021-24',
										prefixIcon: Icons.people, 
										controller: batchController, 
										keyboardType: TextInputType.number,
										validator: (input) {
											if(input!.trim() == '') {
												return 'Batch is required';
											}
											else if(input.trim().length != 7) {
												return 'Invalid batch';
											}
											else {
												RegExp batchRegex = RegExp(r'^\d{4}-(\d{2})$');
												if(!batchRegex.hasMatch(input.trim())) {
													return 'Input on format 2021-24';
												}
												else {
													int startYear = int.tryParse(input.substring(0, 4)) ?? 0;
  													int endYear = int.tryParse(input.substring(5, 7)) ?? 0;
													if(startYear - endYear != 1997) {
														return 'Batch years mismatch';
													}
												}
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
					showDialog(
						context: context, 
						builder: (context) {
							return AlertDialog(
								icon: const Icon(Icons.warning_outlined),
								content: ConstrainedBox(
									constraints: const BoxConstraints(
										maxWidth: 200
									),
									child: Text(
										"Student with Register Number ${student.regNo} already exists. Click 'SAVE' to replace exisiting data",
										textAlign: TextAlign.center,
									),
								),
								actionsAlignment: MainAxisAlignment.spaceAround,
								actionsPadding: const EdgeInsets.only(bottom: 20),
								actions: [
									ElevatedButton(
										onPressed: () {
											Navigator.pop(context);
										},
										style: ElevatedButton.styleFrom(
											backgroundColor: Colors.black
										),
										child: const Text('Discard')
									),
									ElevatedButton(
										onPressed: () async {
											await FirebaseFirestore.instance.collection('students').doc(student.regNo).set(studentData);
											showSnackBar(
												context: context, 
												message: '  Student updated', 
												icon: const Icon(Icons.update, color: Colors.green,), 
												duration: 2
											);
											Provider.of<StudentsProvider>(context, listen: false).addStudent(student);
											_addStudentFormkey.currentState!.reset();
											addUserAuth(student.email);
											Navigator.of(context).pop();
										},
										style: ElevatedButton.styleFrom(
											backgroundColor: Colors.black
										),
										child: const Text('  Save  ')
									),
								],
							);
						}
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

	Future<void> showTheAlertDialog(BuildContext context, String regNo) {
		return showDialog(
			context: context, 
			builder: (context) {
				return AlertDialog(
					icon: const Icon(Icons.info),
					content: ConstrainedBox(
						constraints: const BoxConstraints(
							maxWidth: 200
						),
						child: Text(
							"Student with Register Number $regNo already exists. Click 'SAVE' to replace exisiting data",
							textAlign: TextAlign.center,
						),
					),
					actionsAlignment: MainAxisAlignment.spaceAround,
					actions: [
						ElevatedButton(
							onPressed: () {
								Navigator.pop(context);
							},
							child: const Text('Save')
						),
						ElevatedButton(
							onPressed: () {
								Navigator.pop(context);
							},
							child: const Text('Discard')
						),
					],
				);
			}
		);
	}

	Future<void> addUserAuth(String email) async {
		final auth = FirebaseAuth.instance;
		await auth.createUserWithEmailAndPassword(
			email: email,
			password: '123456'
		);
		await FirebaseAuth.instance.signOut();
	}
}