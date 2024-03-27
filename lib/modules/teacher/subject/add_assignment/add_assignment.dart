// ignore_for_file: use_build_context_synchronously

import 'package:student_analytics/data_models/assignment_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/teacher/subject/add_assignment/asignment_validator.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import 'package:student_analytics/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAssignmentScreen extends StatelessWidget {
	AddAssignmentScreen({super.key, required this.subjectId});

	final String subjectId;

	final FocusNode _titleFocusNode = FocusNode();
	final FocusNode _descriptionFocusNode = FocusNode();
	final FocusNode _duedateFocusNode = FocusNode();

	final AssignmentValidator _validator = AssignmentValidator();
	final GlobalKey<FormState> _addAssignmentFormKey = GlobalKey<FormState>();
	final ValueNotifier<bool> _addAssignmentButtonNotifier = ValueNotifier(false);

	final TextEditingController _titleController = TextEditingController();
	final TextEditingController _descriptionController = TextEditingController();
	final TextEditingController _dueDateController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () => unFocusAllFields(),
			child: Scaffold(
				backgroundColor: Color(0xFFA95DE7),
				appBar: AppBar(
					backgroundColor: Color(0xFFA95DE7),
					title: const Text('Add Assignment'),
				),
				body: SafeArea(
					child: Container(
						height: double.infinity,
          			width: double.infinity,
					decoration: const BoxDecoration(
						image: DecorationImage(
							image: AssetImage('assets/background_images/bg.jpeg'),
							fit: BoxFit.cover
						),
						
					),
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
														key: _addAssignmentFormKey,
														child: Column(
															mainAxisSize: MainAxisSize.min,
															children: [
																const Text(
																	"Add Assignment",
																	style: TextStyle(
																		fontSize: 28,
																		fontWeight: FontWeight.w800,
																	),
																),
																const SizedBox(height: 20,),
																CustomTextField(
																	labelText: 'Title', 
																	focusNode: _titleFocusNode,
																	prefixIcon: Icons.title, 
																	controller: _titleController, 
																	validator: _validator.title,
																),
																const SizedBox(height: 10,),
																CustomTextField(
																	labelText: 'Description', 
																	prefixIcon: Icons.description, 
																	focusNode: _descriptionFocusNode,
																	controller: _descriptionController, 
																	validator: _validator.description,
																),
																const SizedBox(height: 10,),
																CustomTextField(
																	labelText: 'Due Date', 
																	focusNode: _duedateFocusNode,
																	prefixIcon: Icons.date_range, 
																	controller: _dueDateController, 
																	keyboardType: TextInputType.none,
																	onTap: () => pickDate(context),
																	validator: _validator.dueDate,
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
																			backgroundColor: Color(0xFFA95DE7),
																			shape: RoundedRectangleBorder(
																				borderRadius: BorderRadius.circular(10),
																			)
																		),
																		onPressed: () => addAssignment(context),
																		child: ValueListenableBuilder(
																			valueListenable: _addAssignmentButtonNotifier,
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
										  ),
										),
				)
			),
		);
	}

	Future<void> addAssignment(BuildContext context) async {
		if(_addAssignmentFormKey.currentState!.validate()) {
			_addAssignmentButtonNotifier.value = true;

			final AssignmentModel assignmentModel = AssignmentModel(
				subjectId: subjectId,
				title: _titleController.text,
				description: _descriptionController.text,
				dueDate: _dueDateController.text,
				dateCreated: DateTime.now().toString().substring(0, 19),
				submissions: []
			);
			
			try {
				await FirebaseFirestore.instance.collection('assignments').doc(assignmentModel.dateCreated).set(assignmentModel.toJson());
				showSnackBar(
					context: context,
					message: '  Assignment added',
					icon: const Icon(Icons.done_outline, color: Colors.green,)
				);
				_addAssignmentFormKey.currentState!.reset();
				unFocusAllFields();
			}
			catch(err) {
				sss(err);
				showSnackBar(
					context: context,
					message: '  Operation failed',
					icon: const Icon(Icons.error, color: Colors.red,)
				);
			}
			finally {
				_addAssignmentButtonNotifier.value = false;
			}
		}
 	}

	Future<void> pickDate(BuildContext context) async {
		final DateTime? dateTime = await showDatePicker(
			context: context,
			initialDate: DateTime.now(),
			firstDate: DateTime(2023),
			lastDate: DateTime(2025)
		);
		if(dateTime != null) {
			final String date = dateTime.toString().substring(0, 10);
			_dueDateController.text = date;
		}
		_duedateFocusNode.unfocus();
	}

	void unFocusAllFields() {
		_titleFocusNode.unfocus();
		_descriptionFocusNode.unfocus();
		_duedateFocusNode.unfocus();
	}
}
