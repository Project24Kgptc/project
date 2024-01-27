import 'package:student_analytics/data_models/assignment_model.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import 'package:student_analytics/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAssignmentScreen extends StatelessWidget {
  AddAssignmentScreen({super.key, required this.subjectId});
  final String subjectId;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController dueController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  //add attentence
  Future<void> addAssignment(AssignmentModel assignmentData, context) async {
    try {
      // Reference to the 'subjectRooms' collection
      CollectionReference assignmentCollection =
          FirebaseFirestore.instance.collection('assignment');
      AssignmentModel data = assignmentData;
      // Add a new document to the 'subjectRooms' collection
      await assignmentCollection
          .doc(assignmentData.subjectId+assignmentData.title)
          .set(data.toJson());

      print('assignment added successfully');
      showSnackBar(
          context: context,
          message: 'assignment added successfully',
          icon: Icon(
            Icons.check,
            color: Colors.green,
          ),
          duration: 2);
    } catch (e) {
      print('Error adding assignment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Assignment'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  labelText: 'Title',
                  prefixIcon: Icons.title,
                  controller: titleController,
                  validator: (value) {
                    if (value == '') {
                      return 'invalid';
                    }
                    return null;
                  }),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  labelText: 'Description',
                  prefixIcon: Icons.description_outlined,
                  controller: bodyController,
                  validator: (value) {
                    if (value == '') {
                      return 'invalid';
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  labelText: 'Due Date',
                  prefixIcon: Icons.date_range_outlined,
                  controller: dueController,
                  validator: (value) {
                    if (value == '') {
                      return 'invalid';
                    }
                  }),
              SizedBox(
                height: 15,
              ),
              Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          addAssignment(
                              AssignmentModel(
                                  subjectId: subjectId,
                                  title: titleController.text.trim(),
                                  description: bodyController.text.trim(),
                                  dueDate: dueController.text.trim(),
                                  submissions: []),
                              context);
                          titleController.clear();
                          bodyController.clear();
                          dueController.clear();
                        }
                      },
                      child: Text('Add Assignment')))
            ],
          ),
        ),
      )),
    );
  }
}
