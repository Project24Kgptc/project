import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import '../widgets/text_field.dart';

TextEditingController controller = TextEditingController();
ValueNotifier<bool> addSubjectButtonLoadingNotifier = ValueNotifier(false);

class TeacherAddSubject extends StatelessWidget {
	TeacherAddSubject({super.key, required this.teacherData});

	final TeacherModel teacherData;
	final GlobalKey _addSubjectFormKey = GlobalKey<FormState>();

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
							margin: const EdgeInsets.all(20),
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(20)
							),
							child: Form(
								key: _addSubjectFormKey,
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
											labelText: 'Subject Name', 
											prefixIcon: Icons.subject, 
											controller: controller, 
											validator: (input) {
												return null;
											},
										),
										const SizedBox(height: 10,),
										CustomTextField(
											labelText: 'Course Code', 
											prefixIcon: Icons.abc_sharp, 
											controller: controller, 
											validator: (input) {
												if(input!.trim() == '') {
													return 'Name is required';
												}
												return null;
											},
										),
										const SizedBox(height: 10,),
										CustomTextField(
											labelText: 'Semester', 
											prefixIcon: Icons.numbers, 
											controller: controller, 
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
												onPressed: () => {},
												child: ValueListenableBuilder(
													valueListenable: addSubjectButtonLoadingNotifier,
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
}