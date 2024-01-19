// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/admin/admin_dash.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/student/std_dash.dart';
import 'package:student_analytics/teacher/teacher_dash.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import 'package:student_analytics/widgets/text_field.dart';

ValueNotifier selectedLoginNotifier = ValueNotifier(true);
ValueNotifier loginButtonLoadingNotifier = ValueNotifier(false);
ValueNotifier passwordVisibleNotifier = ValueNotifier(false);

TextEditingController emailController = TextEditingController();
TextEditingController passwordController= TextEditingController();

class LoginPage extends StatelessWidget {
	LoginPage({super.key});

	final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

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
										onTap: () => selectedLoginNotifier.value = !selectedLoginNotifier.value,
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
														valueListenable: selectedLoginNotifier,
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
													const SizedBox(height: 15,),
													ValueListenableBuilder(
														valueListenable: selectedLoginNotifier,
														builder: (context, value, child) {
															return CustomTextField(
																controller: emailController,
																keyboardType: value ? TextInputType.number : TextInputType.emailAddress,
																labelText: value ? 'Register Number' : 'Email',
																prefixIcon: Icons.email,
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
														valueListenable: passwordVisibleNotifier,
														builder: (context, value, child) {
															return CustomTextField(
																controller: passwordController,
																obscureText: !value,
																labelText: "Password",
																prefixIcon: Icons.lock,
																suffixIcon: IconButton(
																	onPressed: () => passwordVisibleNotifier.value = !passwordVisibleNotifier.value,
																	icon: Icon(value ? Icons.visibility : Icons.visibility_off, color: Colors.black, size: 20,),
																),
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
																	if(selectedLoginNotifier.value) {
																		studentLoginFunctionality(context);
																	}
																	else {
																		teacherLoginFunctionality(context);
																	}
																}
															},
															child: ValueListenableBuilder(
																valueListenable: loginButtonLoadingNotifier,
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
		if(passwordController.text.trim().length > 5) {
			loginButtonLoadingNotifier.value = true;
			FirebaseAuth auth = FirebaseAuth.instance;
			try {
				final UserCredential userCredential = await auth.signInWithEmailAndPassword(
					email: '${emailController.text.trim()}@mail.com',
					password: passwordController.text.trim()
				);

				final studentData = await FirebaseFirestore.instance.collection('students').doc(userCredential.user!.email!.replaceAll('@mail.com', '')).get();
				Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => StudentDashboard(studentData: StudentModel.fromMaptoObject(studentData.data()!))));
				_loginFormKey.currentState!.reset();
			}
			on FirebaseAuthException catch(e) {
				if(e.code == 'invalid-credential') {
					showSnackBar(
						context: context, 
						message: '  Incorrect Register Number or Password !', 
						icon: const Icon(Icons.error, color: Colors.red,), 
						duration: 5
					);
				}
			}
			catch(err) {
				showSnackBar(
					context: context, 
					message: '  Error occured !', 
					icon: const Icon(Icons.error_sharp, color: Colors.red,), 
					duration: 3
				);
			}
			finally {
				loginButtonLoadingNotifier.value = false;
			}
		}
		else {
			await Future.delayed(const Duration(seconds: 1));
			showSnackBar(
				context: context, 
				message: '  Incorrect Register Number or Password !', 
				icon: const Icon(Icons.error, color: Colors.red,), 
				duration: 2
			);
		}
	}

	Future<void> teacherLoginFunctionality(BuildContext context) async {
		if(passwordController.text.trim().length > 5) {
			loginButtonLoadingNotifier.value = true;
			FirebaseAuth auth = FirebaseAuth.instance;
			try {
				final UserCredential userCredential = await auth.signInWithEmailAndPassword(
					email: emailController.text.trim(),
					password: passwordController.text.trim()
				);print(userCredential);

				final teacherData = await FirebaseFirestore.instance.collection('teachers').doc(userCredential.user!.email!.replaceAll('@mail.com', '')).get();
				if(teacherData.exists) {
					_loginFormKey.currentState!.reset();
					Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => TeacherDashboard(teacherData: TeacherModel.fromMaptoObject(teacherData.data()!))));
				}

				final adminData = await FirebaseFirestore.instance.collection('admins').doc(userCredential.user!.email!.replaceAll('@mail.com', '')).get();
				if(adminData.exists) {
					_loginFormKey.currentState!.reset();
					Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => AdminDashboard(adminName: adminData.data()!['name'])));
				}
			}
			on FirebaseAuthException catch(e) {
				if(e.code == 'invalid-credential') {
					showSnackBar(
						context: context, 
						message: '  Incorrect Register Number or Password !', 
						icon: const Icon(Icons.error, color: Colors.red,), 
						duration: 5
					);
				}
			}
			catch(err) {
				showSnackBar(
					context: context, 
					message: '  Error occured !', 
					icon: const Icon(Icons.error_sharp, color: Colors.red,), 
					duration: 3
				);
			}
			finally {
				loginButtonLoadingNotifier.value = false;
			}
		}
		else {
			await Future.delayed(const Duration(seconds: 1));
			showSnackBar(
				context: context, 
				message: '  Incorrect Email or Password !', 
				icon: const Icon(Icons.error, color: Colors.red,), 
				duration: 2
			);
		}
	}
}