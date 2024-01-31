// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/admin_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/admin/admin_dash.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/provider/subject_provider.dart';
import 'package:student_analytics/modules/student/std_dash.dart';
import 'package:student_analytics/modules/teacher/teacher_dash.dart';
import 'package:student_analytics/widgets/text_field.dart';

class LoginPage extends StatelessWidget {
	LoginPage({super.key});

	final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

	final ValueNotifier<bool> _selectedLoginNotifier = ValueNotifier(true);
	final ValueNotifier<bool> _loginButtonLoadingNotifier = ValueNotifier(false);
	final ValueNotifier<bool> _passwordVisibleNotifier = ValueNotifier(false);
	final ValueNotifier<String> _loginErrorMessageNotifier = ValueNotifier('');

	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController= TextEditingController();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.deepPurpleAccent,
			body: SafeArea(
				child: Center(
					child: SingleChildScrollView(
						child: Container(
							margin: const EdgeInsets.all(30),
							padding: const EdgeInsets.symmetric(horizontal: 5),
							decoration: const BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.all(Radius.circular(10)),
							),
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									InkWell(
										onTap: () => _selectedLoginNotifier.value = !_selectedLoginNotifier.value,
										child: Container(
											margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
											decoration: BoxDecoration(
												color: const Color(0xFF5063A3),
												borderRadius: BorderRadius.circular(20)
											),
											child: Stack(
												children: [
													const Row(
														mainAxisAlignment: MainAxisAlignment.spaceAround,
														children: [
															Padding(
																padding: EdgeInsets.all(10),
																child: Text(
																	'Student',
																	style: TextStyle(
																		color: Color(0xFFF1F1F1),
																		fontSize: 18,
																		fontWeight: FontWeight.w800
																	),
																),
															),
															Padding(
																padding: EdgeInsets.all(10),
																child: Text(
																	'Teacher',
																	style: TextStyle(
																		color: Color(0xFFF1F1F1),
																		fontSize: 18,
																		fontWeight: FontWeight.w800
																	),
																),
															),
														],
													),
													ValueListenableBuilder(
														valueListenable: _selectedLoginNotifier,
														builder: (context, value, child) {
															return AnimatedPositioned(
																left: value ? 0 : (MediaQuery.of(context).size.width/2) - 95,
																duration: const Duration(milliseconds: 250),
																child: Container(
																	width: (MediaQuery.of(context).size.width/2) - 75,
																	decoration: BoxDecoration(
																		color: Colors.deepPurpleAccent,
																		borderRadius: BorderRadius.circular(20)
																	),
																	child: Padding(
																		padding: const EdgeInsets.all(10),
																		child: Text(
																			value ? 'Student' : 'Teacher',
																			textAlign: TextAlign.center,
																			style: const TextStyle(
																				color: Colors.white,
																				fontSize: 18,
																				fontWeight: FontWeight.w800
																			),
																		),
																	),
																)
															);
														},
													)
												],
											),
										),
									),
									Container(
										padding: const EdgeInsets.symmetric(horizontal: 10),
										child: Form(
											key: _loginFormKey,
											child: Column(
												mainAxisSize: MainAxisSize.min,
												children: [
													const Text(
														"Login",
														style: TextStyle(
															fontSize: 28,
															fontWeight: FontWeight.w700,
														),
													),
													const SizedBox(height: 6),
													ValueListenableBuilder(
														valueListenable: _loginErrorMessageNotifier,
														builder: (context, value, child) {
															return Visibility(
																visible: value != '',
																child: Text(
																	value,
																	style: const TextStyle(
																		color: Colors.red
																	),
																),
															);
														},
													),
													const SizedBox(height: 15),
													ValueListenableBuilder(
														valueListenable: _selectedLoginNotifier,
														builder: (context, value, child) {
															return CustomTextField(
																controller: _emailController,
																keyboardType: value ? TextInputType.number : TextInputType.emailAddress,
																labelText: value ? 'Register Number' : 'Email',
																prefixIcon: Icons.email,
																onChange: (_) => _loginErrorMessageNotifier.value = '',
																validator: (input) {
																	if(value) {
																		final RegExp regNoRegEx = RegExp(r'^[0-9]+$');
																		if(input!.trim() == '') {
																			return 'Please enter your Register Number';
																		}
																		else if(input.trim().length != 4 || !regNoRegEx.hasMatch(input)) {
																			return 'Please provide a valid Register number';
																		}
																	}
																	else {
																		final RegExp emailRegExp = RegExp( r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
																		if(input!.trim() == '') {
																			return "Please enter your email";
																		}
																		else if(!emailRegExp.hasMatch(input.trim())) {
																			return 'Please provide a valid email !';
																		}
																	}
																	return null;
																},
															);
														},
													),
													const SizedBox(height: 10,),
													ValueListenableBuilder(
														valueListenable: _passwordVisibleNotifier,
														builder: (context, value, child) {
															return CustomTextField(
																controller: _passwordController,
																obscureText: !value,
																labelText: "Password",
																prefixIcon: Icons.lock,
																suffixIcon: IconButton(
																	onPressed: () => _passwordVisibleNotifier.value = !_passwordVisibleNotifier.value,
																	icon: Icon(value ? Icons.visibility : Icons.visibility_off, color: Colors.black, size: 20,),
																),
																onChange: (_) => _loginErrorMessageNotifier.value = '',
																validator: (value) {
																	if(value!.trim() == '') {
																		return 'Please enter your password';
																	}
																	else {
																		return null;
																	}
																}
															);
														},
													),
													const SizedBox(height: 20,),
													Container(
														height: 45,
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
																if(_loginFormKey.currentState!.validate()) {
																	if(_selectedLoginNotifier.value) {
																		studentLoginFunctionality(context);
																	}
																	else {
																		teacherLoginFunctionality(context);
																	}
																}
															},
															child: ValueListenableBuilder(
																valueListenable: _loginButtonLoadingNotifier,
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
																			'Login',
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
													const SizedBox(height: 30,)
												],
											),
										)
									)
								],
							),
						),
					)
				),
			),
		);
	}

	Future<void> studentLoginFunctionality(BuildContext context) async {
		if(_passwordController.text.trim().length > 5) {
			_loginButtonLoadingNotifier.value = true;
			FirebaseAuth auth = FirebaseAuth.instance;
			try {
				final UserCredential userCredential = await auth.signInWithEmailAndPassword(
					email: '${_emailController.text.trim()}@mail.com',
					password: _passwordController.text.trim()
				);

				final studentData = await FirebaseFirestore.instance.collection('students').doc(userCredential.user!.email!.replaceAll('@mail.com', '')).get();
				Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => StudentDashboard(studentData: StudentModel.fromMaptoObject(studentData.data()!))));
				_loginFormKey.currentState!.reset();
			}
			on FirebaseAuthException catch(e) {
				if(e.code == 'invalid-credential') {
					_loginErrorMessageNotifier.value = '  Incorrect Register Number or Password !';
				}
			}
			catch(err) {
				sss(err);
				_loginErrorMessageNotifier.value = '  Something went wrong !';
			}
			finally {
				_loginButtonLoadingNotifier.value = false;
			}
		}
		else {
			await Future.delayed(const Duration(seconds: 1));
			_loginErrorMessageNotifier.value = '  Incorrect Register Number or Password !';
		}
	}

	Future<void> teacherLoginFunctionality(BuildContext context) async {
		if(_passwordController.text.trim().length > 5) {
			_loginButtonLoadingNotifier.value = true;
			FirebaseAuth auth = FirebaseAuth.instance;
			try {
				final UserCredential userCredential = await auth.signInWithEmailAndPassword(
					email: _emailController.text.trim(),
					password: _passwordController.text.trim()
				);

				final teacherData = await FirebaseFirestore.instance.collection('teachers').doc(userCredential.user!.email!.replaceAll('@mail.com', '')).get();
				if(teacherData.exists) {
					_loginFormKey.currentState!.reset();
					final TeacherModel teacherModel = TeacherModel.fromMaptoObject(teacherData.data()!);
					Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => TeacherDashboard(teacherData: teacherModel)));
				
					final subjects = await FirebaseFirestore.instance.collection('subjects').where('teacherId', isEqualTo: teacherModel.teacherId).get();
					await Future.delayed(const Duration(microseconds: 100));
					final List<SubjectModel> subjectObjectsList = subjects.docs.map((subject) => SubjectModel.fromMaptoObject(subject.data())).toList();
					Provider.of<SubjectProvider>(context, listen: false).setAllSubjectsData(subjectObjectsList);
				}

				final adminData = await FirebaseFirestore.instance.collection('admins').doc(userCredential.user!.email!.replaceAll('@mail.com', '')).get();
				if(adminData.exists) {
					_loginFormKey.currentState!.reset();
					final AdminModel adminModel = AdminModel.fromMaptoObject(adminData.data()!);
					Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => AdminDashboard(adminModel: adminModel)));
				}
			}
			on FirebaseAuthException catch(e) {
				if(e.code == 'invalid-credential') {
					_loginErrorMessageNotifier.value = '  Incorrect Email or Password !';
				}
			}
			catch(err) {
				sss(err);
				_loginErrorMessageNotifier.value = '  Something went wrong !';
			}
			finally {
				_loginButtonLoadingNotifier.value = false;
			}
		}
		else {
			await Future.delayed(const Duration(seconds: 1));
			_loginErrorMessageNotifier.value = '  Incorrect Email or Password !';
		}
	}
}