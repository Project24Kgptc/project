// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/provider/subject_provider.dart';
import 'package:student_analytics/widgets/alert_dialog.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import 'package:student_analytics/widgets/text_field.dart';

ValueNotifier<bool> addSubjectButtonNotifier = ValueNotifier(false);
ValueNotifier<String> batchDropDownNotifier = ValueNotifier('');

TextEditingController courseCodeController = TextEditingController();
TextEditingController courseNameController = TextEditingController();
TextEditingController semesterController = TextEditingController();
String? batchDropDownController;

class AddSubject extends StatelessWidget {
	AddSubject({super.key, required this.teacherName, required this.teacherId, required this.batchesList});

	final FocusNode _dropdownFocus = FocusNode();
	final String teacherName;
	final List<String> batchesList;
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
												if(input!.trim() == '') {
													return 'Course code is required';
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
													return 'Course name is required';
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
												final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
												if(input!.trim() == '') {
													return 'Semester is required';
												}
												else if(!numberCheckRegex.hasMatch(input)) {
													return 'Invalid semester';
												}
												return null;
											},
										),
										const SizedBox(height: 10,),
										DropdownButtonFormField<String>(
											focusNode: _dropdownFocus,
											decoration: InputDecoration(
												labelText: 'Select Batch',
												prefixIcon: const Icon(Icons.batch_prediction),
												prefixIconColor: MaterialStateColor.resolveWith((states) {
													return states.contains(MaterialState.focused) ? Colors.deepPurpleAccent : Colors.black;
												}),
												floatingLabelStyle: const TextStyle(
													color: Colors.deepPurpleAccent
												),
												border: OutlineInputBorder(
													borderSide: const BorderSide(
														color: Colors.black,
													),
													borderRadius: BorderRadius.circular(30)
												),
												enabledBorder: OutlineInputBorder(
													borderSide: const BorderSide(
														color: Colors.black,
													),
													borderRadius: BorderRadius.circular(30)
												),
												focusedBorder: OutlineInputBorder(
													borderSide: const BorderSide(
														color: Colors.deepPurpleAccent,
													),
													borderRadius: BorderRadius.circular(30)
												),
											),
											items: batchesList.map((String value) {
												return DropdownMenuItem<String>(
													value: value,
													child: Text(value),
												);
											}).toList(),
											onChanged: (String? value) {
												batchDropDownController = value;
											},
											value: batchDropDownController,
											validator: (value) => value == null ? "Select batch" : null
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
												onPressed: () => addSubject(context),
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
		if(_addSubjectFormkey.currentState!.validate()) {
			final String subjectId = '${courseCodeController.text}-${batchDropDownController!}'; // eg. 4131-2021-24
			final subjectModel = SubjectModel(
				subjectId: subjectId,
				teacherId: teacherId,
				teacherName: teacherName,
				courseCode: courseCodeController.text,
				semester: semesterController.text,
				subjectName: courseNameController.text,
				batch: batchDropDownController!
			);
			try {
				final isExisting = await FirebaseFirestore.instance.collection('subjects').doc(subjectId).get();
				if(isExisting.exists) {
					customAlertDialog(
						context: context,
						messageText: 'Subject with code ${subjectModel.courseCode} already exists for batch ${subjectModel.batch}',
						primaryButtonText: 'Back',
						isSecondButtonVisible: false,
						onPrimaryButtonClick: () => Navigator.of(context).pop(),
					);
				}
				else {
					addSUbjectToStudents(subjectModel.subjectId, subjectModel.batch);
					await FirebaseFirestore.instance.collection('subjects').doc(subjectModel.subjectId).set(subjectModel.toMap());
					showSnackBar(
						context: context, 
						message: '  Subject added', 
						icon: const Icon(Icons.done_outline, color: Colors.green,), 
						duration: 2
					);
					Provider.of<SubjectProvider>(context, listen: false).addSubject(subjectModel);
					_addSubjectFormkey.currentState!.reset();
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
				addSubjectButtonNotifier.value = false;
			}
		}
		addSubjectButtonNotifier.value = false;
	}

	Future<void> addSUbjectToStudents(String subjectId, String batch) async {
		final students = await FirebaseFirestore.instance.collection('students').where('batch', isEqualTo: batch).get();
		for (var student in students.docs) {
			final List subjectsList = student.data()['subjects'];
			subjectsList.add(subjectId);
			await FirebaseFirestore.instance.collection('students').doc(student.id).update({'subjects': subjectsList});
		}
	}
  
}
