// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/widgets/alert_dialog.dart';
import 'package:student_analytics/widgets/text_field.dart';

import '../../widgets/snack_bar.dart';

class ForgotPassword extends StatelessWidget {
	ForgotPassword({super.key});

	final TextEditingController _emailController = TextEditingController();
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	final ValueNotifier<bool> _buttonLoadingNotifier = ValueNotifier(false);
	final ValueNotifier<String> _errorMessageNotifier = ValueNotifier('');

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.deepPurpleAccent,
			body: SafeArea(
				child: Center(
					child: Container(
						padding: const EdgeInsets.all(20),
						margin: const EdgeInsets.all(10),
						decoration: const BoxDecoration(
						color: Colors.white,
						borderRadius: BorderRadius.all(Radius.circular(10)),
						),
						child: Form(
							key: _formKey,
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									ValueListenableBuilder(
										valueListenable: _errorMessageNotifier,
										builder: (context, value, child) {
										    return Visibility(
												visible: value != '',
												child: Text(
													value,
													style: const TextStyle(color: Colors.red),
												),
                              				);
										},
									),
									const SizedBox(height: 10,),
									CustomTextField(
										controller: _emailController,
										labelText: "Email", 
										keyboardType: TextInputType.emailAddress,
										prefixIcon: Icons.email, 
										onFieldSubmit: (str) {
											if (_formKey.currentState!.validate()) {
												onSubmit(context);
											}
										},
										validator: (input) {
											final RegExp emailRegExp = RegExp(
													r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
												if (input!.trim() == '') {
												return "Please enter your email";
												} else if (!emailRegExp
													.hasMatch(input.trim())) {
												return 'Please provide a valid email !';
												}
											return null;
											},
									),
									const SizedBox(height:  20,),
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
												if (_formKey.currentState!.validate()) {
													onSubmit(context);
												}
											},
											child: ValueListenableBuilder(
												valueListenable: _buttonLoadingNotifier,
												builder: (context, value, child) {
													if (value) {
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
														return const Text('Submit',
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
								],
							),
						)
					),
				),
			),
		);
	}

	Future<void> onSubmit(BuildContext context) async {
		_buttonLoadingNotifier.value = true;
		try {
			final user = await isUserExists(_emailController.text.trim(), context);
			if(user) {
				sendOtp(context);
			}
			else {
				_errorMessageNotifier.value = 'User not found !';
			}
		}
		catch(err) {
			sss(err);
			showSnackBar(
				context: context, 
				message: '  Something went wrong !', 
				icon: const Icon(Icons.feedback, color: Colors.red,), 
				duration: 2
			);
		}
		finally {
			_buttonLoadingNotifier.value = false;
		}
	}

	Future<bool> isUserExists(String regNo, BuildContext context) async {
		try {
			final student = await FirebaseFirestore.instance.collection('students').doc(_emailController.text.trim()).get();
			if(student.exists) {
				return true;
			}

			final teacher = await FirebaseFirestore.instance.collection('teachers').doc(_emailController.text.trim()).get();
			if(teacher.exists) {
				return true;
			}

			final admin = await FirebaseFirestore.instance.collection('admins').doc(_emailController.text.trim()).get();
			if(admin.exists) {
				return true;
			}
			
			return false;
		}
		catch(err) {
			sss(err);
			rethrow;
		}
	}

	Future<void> sendOtp(BuildContext context) async {
		try {
			// await _emailOTP.setConfig(
			// 	appEmail: 'studentAnalytics24@gmail.com',
			// 	appName: 'Student Analytics',
			// 	userEmail: user['email'],
			// 	otpLength: 4,
			// 	otpType: OTPType.digitsOnly
			// );
			// final bool send = await _emailOTP.sendOTP();
			// if(send) {
			// 	Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpCheckout(emailOTP: _emailOTP, user: user,)));
			// }

			await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
			customAlertDialog(
				context: context,
				messageText: "Check your mail to get the recovery option",
				onPrimaryButtonClick: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => LoginPage()), (route) => false),
				primaryButtonText: "Back",
				isSecondButtonVisible: false
			);
		}
		catch(err) {
			sss(err);
			showSnackBar(
				context: context, 
				message: '  Something went wrong !', 
				icon: const Icon(Icons.feedback, color: Colors.red,), 
				duration: 2
			);
		}
	}
}