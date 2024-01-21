// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/provider/teachers_provider.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import '../widgets/text_field.dart';

ValueNotifier<bool> addTeacherButtonLoadingNotifier = ValueNotifier(false);

TextEditingController teacherIdController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();

class AddTeacher extends StatelessWidget {
	AddTeacher({super.key});

	final GlobalKey<FormState> _addTeacherFormkey = GlobalKey<FormState>();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.deepPurpleAccent,
				title: const Text('Add Teacher'),
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
								key: _addTeacherFormkey,
								child: Column(
									mainAxisSize: MainAxisSize.min,
									children: [
										const Text(
											"Add Teacher",
											style: TextStyle(
												fontSize: 28,
												fontWeight: FontWeight.w800,
											),
										),
										const SizedBox(height: 20,),
										CustomTextField(
											labelText: 'Id', 
											prefixIcon: Icons.perm_identity, 
											keyboardType: TextInputType.number,
											controller: teacherIdController, 
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
												onPressed: () => addTeacher(context),
												child: ValueListenableBuilder(
													valueListenable: addTeacherButtonLoadingNotifier,
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

	Future<void> addTeacher(BuildContext context) async {
		if(_addTeacherFormkey.currentState!.validate()) {		
			addTeacherButtonLoadingNotifier.value = true;
			final TeacherModel teacherModel = TeacherModel(
				teacherId: teacherIdController.text.trim(),
				name: nameController.text.trim(),
				email: emailController.text.trim(),
				phoneNumber: phoneNumberController.text.trim()
			);
			final teacherData = teacherModel.toMap();
			try {
				final teacherExists = await FirebaseFirestore.instance.collection('teachers').doc(teacherModel.email.replaceAll('@mail.com', '')).get();
				if(teacherExists.exists) {
					showTheAlertDialog(context, teacherModel.email, teacherModel);
				}
				else {
					await FirebaseFirestore.instance.collection('teachers').doc(teacherModel.email.replaceAll('@mail.com', '')).set(teacherData);
					showSnackBar(
						context: context, 
						message: '  Teacher added', 
						icon: const Icon(Icons.done_outline, color: Colors.green,), 
						duration: 2
					);
					Provider.of<TeachersProvider>(context, listen: false).addTeacher(teacherModel);
					_addTeacherFormkey.currentState!.reset();

					addUserAuth(teacherModel.email);
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
				addTeacherButtonLoadingNotifier.value = false;
			}
		}
	}

	Future<void> showTheAlertDialog(BuildContext context, String email, TeacherModel teacherModel) {
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
							"Teacher with email $email already exists. Click 'SAVE' to replace exisiting data",
							textAlign: TextAlign.center,
						),
					),
					actionsAlignment: MainAxisAlignment.spaceAround,
					actions: [
						ElevatedButton(
							onPressed: () async {
								await FirebaseFirestore.instance.collection('teachers').doc(teacherModel.email.replaceAll('@mail.com', '')).set(teacherModel.toMap());
								showSnackBar(
									context: context, 
									message: '  Teacher added', 
									icon: const Icon(Icons.done_outline, color: Colors.green,), 
									duration: 2
								);
								Provider.of<TeachersProvider>(context, listen: false).addTeacher(teacherModel);
								_addTeacherFormkey.currentState!.reset();

								addUserAuth(teacherModel.email);
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
			password: '111111'
		);
		await FirebaseAuth.instance.signOut();
	}
}