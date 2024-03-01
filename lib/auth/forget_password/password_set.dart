import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/widgets/text_field.dart';

class ResetpasswordScreen extends StatelessWidget {
	ResetpasswordScreen({super.key, required this.regNo});

	final String regNo;
	final GlobalKey<FormState> _passwordResetFormKey = GlobalKey<FormState>();

	final ValueNotifier<bool> _passwordResetButtonLoadingNotifier = ValueNotifier(false);
	final ValueNotifier<String> _errorMessageNotifier = ValueNotifier('');

	final TextEditingController _newPasswordController = TextEditingController();
	final TextEditingController _confirmPasswordController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
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
								key: _passwordResetFormKey,
								child: Column(
									mainAxisSize: MainAxisSize.min,
									children: [
										const Text(
											"Set new password",
											style: TextStyle(
												fontSize: 28,
												fontWeight: FontWeight.w800,
											),
										),
										const SizedBox(height: 6),
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
										const SizedBox(height: 15),
										CustomTextField(
											labelText: 'New Password', 
											prefixIcon: Icons.lock, 
											controller: _newPasswordController, 
											validator: (input) => input!.trim() == '' ? 'Enter password' : null,
											onChange: (s) => _errorMessageNotifier.value = '',
										),
										const SizedBox(height: 10,),
										CustomTextField(
											labelText: 'Confirm New', 
											prefixIcon: Icons.lock, 
											controller: _confirmPasswordController, 
											keyboardType: TextInputType.number,
											validator: (input) => input!.trim() == '' ? 'Enter password' : null,
											onChange: (s) => _errorMessageNotifier.value = '',
										),
										const SizedBox(height: 10,),
										
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
												onPressed: () => resetPassword(context),
												child: ValueListenableBuilder(
													valueListenable: _passwordResetButtonLoadingNotifier,
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
																'Reset',
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
				),
			),
		);
	}

	Future<void> resetPassword(BuildContext context) async {
		if(_passwordResetFormKey.currentState!.validate()) {
			if(_confirmPasswordController.text != _newPasswordController.text) {
				_errorMessageNotifier.value = 'Passwords not matching !';
			}
			else {
				final userCredential = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
					'$regNo@mail.com',
				);
				
			}
		}
	}
}