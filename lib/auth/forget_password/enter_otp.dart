// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:student_analytics/auth/forget_password/password_set.dart';
import 'package:student_analytics/main.dart';

import '../../widgets/snack_bar.dart';

class OtpCheckout extends StatelessWidget {
  	OtpCheckout({super.key, required this.emailOTP, required this.user});

	final TextEditingController _otpController = TextEditingController();
	final ValueNotifier<bool> _buttonLoadingNotifier = ValueNotifier(false);

	final EmailOTP emailOTP;
	final Map<String, dynamic> user;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.deepPurpleAccent,
			body: SafeArea(
				child: Center(
					child: Container(
						padding: const EdgeInsets.all(20),
						margin: const EdgeInsets.all(10),
						decoration: BoxDecoration(
							color: Colors.white,
							borderRadius: BorderRadius.circular(20)
						),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								const Text(
									'Enter the OTP send to your registered email address',
									style: TextStyle(
										fontSize: 17,
										fontWeight: FontWeight.w400
									),
								),
								const SizedBox(height: 10,),
								TextField(
									controller: _otpController,
									keyboardType: TextInputType.number,
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
										onPressed: () => verifyOtp(context),
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
											} else {
											return const Text('Submit',
												style: TextStyle(
													fontSize: 19,
													fontWeight: FontWeight.w900
													)
												);
											}
										},
										)),
								),
							],
						),
					),
				),
			),
		);
	}

	Future<void> verifyOtp(BuildContext context) async {
		_buttonLoadingNotifier.value = true;
		try {
			final bool verify = await emailOTP.verifyOTP(otp: _otpController.text);
			if(verify) {
				Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetpasswordScreen(regNo: user['regNo'],)));
			}
			else {
				showSnackBar(
					context: context, 
					message: '  Inalid OTP !', 
					icon: const Icon(Icons.feedback, color: Colors.red,), 
					duration: 2
				);
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
}