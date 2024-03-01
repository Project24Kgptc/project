// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/auth/forget_password/forget_password.dart';
import 'package:student_analytics/data_models/admin_model.dart';
import 'package:student_analytics/data_models/attendance_model.dart';
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

  final ValueNotifier<bool> _loginButtonLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _passwordVisibleNotifier = ValueNotifier(false);
  final ValueNotifier<String> _loginErrorMessageNotifier = ValueNotifier('');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
				const SizedBox(height: 20,),
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
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: 'Email',
                            prefixIcon: Icons.email,
                            onChange: (_) =>
                                _loginErrorMessageNotifier.value = '',
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
                          const SizedBox(
                            height: 10,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _passwordVisibleNotifier,
                            builder: (context, value, child) {
                              return CustomTextField(
                                  controller: _passwordController,
                                  obscureText: !value,
                                  labelText: "Password",
                                  prefixIcon: Icons.lock,
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        _passwordVisibleNotifier.value =
                                            !_passwordVisibleNotifier.value,
                                    icon: Icon(
                                      value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  onChange: (_) =>
                                      _loginErrorMessageNotifier.value = '',
                                  validator: (value) {
                                    if (value!.trim() == '') {
                                      return 'Please enter your password';
                                    } else {
                                      return null;
                                    }
                                  });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
						  Align(
							alignment: Alignment.bottomRight,
							child: TextButton(
							onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword(),)), 
							child: const Text(
								'forget password', 
								textAlign: TextAlign.right, 
								style: TextStyle(
									color: Colors.black
								),
							)
						  ),
						  ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70)),
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                onPressed: () {
                                  if (_loginFormKey.currentState!.validate()) {
                                    login(context);
                                  }
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: _loginButtonLoadingNotifier,
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
                                      return const Text('Login',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w900
											)
										);
                                    }
                                  },
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        )),
      ),
    );
  }

	Future<void> login(BuildContext context) async {
		if (_passwordController.text.trim().length > 5) {
			_loginButtonLoadingNotifier.value = true;
			FirebaseAuth auth = FirebaseAuth.instance;
			try {
				final UserCredential userCredential = await auth.signInWithEmailAndPassword(
					email: _emailController.text.trim(),
					password: _passwordController.text.trim()
				);
				
				/***********************************************************************************************/
				final studentData = await FirebaseFirestore.instance
				.collection('students').doc(userCredential.user!.email!)
				.get();
				if (studentData.exists) {
					_loginFormKey.currentState!.reset();
					final StudentModel studentModel = StudentModel.fromMaptoObject(studentData.data()!);
					final List<SubjectModel> subjectList = await getSubjects(studentModel);
					final List<AttendanceModel> attendances = await getAllAttendance();
					Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => StudentDashboard(subjects: subjectList, studentData: studentModel, attentencelist: attendances,)));
					return;
				}
				/***********************************************************************************************/


				/***********************************************************************************************/
				final teacherData = await FirebaseFirestore.instance
				.collection('teacher').doc(userCredential.user!.email!)
				.get();
				if (teacherData.exists) {
					_loginFormKey.currentState!.reset();
					final TeacherModel teacherModel = TeacherModel.fromMaptoObject(teacherData.data()!);
					Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => TeacherDashboard(teacherData: teacherModel,)));
					return;
				}
				/***********************************************************************************************/


				/***********************************************************************************************/
				final adminData = await FirebaseFirestore.instance
				.collection('admins').doc(userCredential.user!.email!)
				.get();
				if (adminData.exists) {
					_loginFormKey.currentState!.reset();
					final AdminModel adminModel = AdminModel.fromMaptoObject(adminData.data()!);
					Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => AdminDashboard(adminModel: adminModel)));
					return;
				}
				/***********************************************************************************************/

				// final studentData = await FirebaseFirestore.instance
				// 	.collection('students')
				// 	.doc(userCredential.user!.email!.replaceAll('@mail.com', ''))
				// 	.get();
				// List<SubjectModel>? subjects =
				// 	await getSubjectsByStudentId(studentData['regNo']);
				// List<AttendanceModel> attentence = await getAllAttendance();
				// Navigator.of(context).pushReplacement(MaterialPageRoute(
				// 	builder: (ctx) => StudentDashboard(
				// 	attentencelist: attentence,
				// 		subjects: subjects!,
				// 		studentData:
				// 			StudentModel.fromMaptoObject(studentData.data()!))));
				// _loginFormKey.currentState!.reset();
			} on FirebaseAuthException catch (e) {
				if (e.code == 'invalid-credential') {
				_loginErrorMessageNotifier.value =
					'  Incorrect Email Number or Password !';
				}
			} catch (err) {
				sss(err);
				_loginErrorMessageNotifier.value = '  Something went wrong !';
			} finally {
				_loginButtonLoadingNotifier.value = false;
			}
			} else {
			await Future.delayed(const Duration(seconds: 1));
			_loginErrorMessageNotifier.value =
				'  Incorrect Register Number or Password !';
		}
	}

  	Future<void> teacherLoginFunctionality(BuildContext context) async {
    if (_passwordController.text.trim().length > 5) {
      _loginButtonLoadingNotifier.value = true;
      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        final UserCredential userCredential =
            await auth.signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        final teacherData = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(userCredential.user!.email!.replaceAll('@mail.com', ''))
            .get();
        if (teacherData.exists) {
          _loginFormKey.currentState!.reset();
          final TeacherModel teacherModel =
              TeacherModel.fromMaptoObject(teacherData.data()!);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => TeacherDashboard(teacherData: teacherModel)));

          final subjects = await FirebaseFirestore.instance
              .collection('subjects')
              .where('teacherId', isEqualTo: teacherModel.teacherId)
              .get();
          await Future.delayed(const Duration(microseconds: 100));
          final List<SubjectModel> subjectObjectsList = subjects.docs
              .map((subject) => SubjectModel.fromMaptoObject(subject.data()))
              .toList();
          Provider.of<SubjectProvider>(context, listen: false)
              .setAllSubjectsData(subjectObjectsList);
        }

        final adminData = await FirebaseFirestore.instance
            .collection('admins')
            .doc(userCredential.user!.email!.replaceAll('@mail.com', ''))
            .get();
        if (adminData.exists) {
          _loginFormKey.currentState!.reset();
          final AdminModel adminModel =
              AdminModel.fromMaptoObject(adminData.data()!);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => AdminDashboard(adminModel: adminModel)));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          _loginErrorMessageNotifier.value = '  Incorrect Email or Password !';
        }
      } catch (err) {
        sss(err);
        _loginErrorMessageNotifier.value = '  Something went wrong !';
      } finally {
        _loginButtonLoadingNotifier.value = false;
      }
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _loginErrorMessageNotifier.value = '  Incorrect Email or Password !';
    }
  }

  	Future<List<SubjectModel>> getSubjects(StudentModel studentModel) async {
		try {
			final List<String> subjectIds = List<String>.from(studentModel.subjects);

			if (subjectIds.isNotEmpty) {
				final subjects = await FirebaseFirestore.instance
					.collection('subjects')
					.where('subjectId', whereIn: subjectIds)
					.get();

				final List<SubjectModel> subjectList = subjects.docs
					.map((e) => SubjectModel.fromMaptoObject(e.data()))
					.toList();

				return subjectList;
			}
			else {
				return [];
			}
		}
		catch (e) {
			sss('Error: $e');
			return [];
		}
	}
	
	Future<List<AttendanceModel>> getAllAttendance() async {
		try {
			QuerySnapshot attendances = await FirebaseFirestore.instance.collection('attentence').get();

			List<AttendanceModel> attendance = attendances.docs.map((DocumentSnapshot document) => 
				AttendanceModel.fromMap(document.data() as Map<String, dynamic>)
			).toList();

			return attendance;
		}
		catch (e) {
			sss('error: $e');
			rethrow;
		}
	}
}