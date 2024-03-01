// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_analytics/data_models/assignment_model.dart';
import 'package:student_analytics/data_models/seriestest_mark_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/widgets/alert_dialog.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class AddAssignmentMark extends StatelessWidget {
  AddAssignmentMark(
      {super.key,
      required this.subjectModel,
      required this.seriesTestMarkModel,
      required this.assignmentdata});

  final SubjectModel subjectModel;
  final List<AddMarkModel> seriesTestMarkModel;
  final AssignmentModel assignmentdata;

  final GlobalKey<FormState> _addAssignmentMarkFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Add Assignment Mark'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () => saveSeriesTestData(context),
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.deepPurpleAccent),
                  side:
                      MaterialStatePropertyAll(BorderSide(color: Colors.white)),
                  shadowColor: MaterialStatePropertyAll(Colors.white)),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _addAssignmentMarkFormKey,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.deepPurpleAccent,
                            spreadRadius: 1,
                            blurRadius: 5)
                      ]),
                  child: Text(assignmentdata.title)),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.all(5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.deepPurpleAccent,
                              spreadRadius: 1,
                              blurRadius: 5)
                        ]),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(-1, 1))
                              ]),
                          child: ListTile(
                            onTap: () => seriesTestMarkModel[index]
                                .focusNode
                                .requestFocus(),
                            leading: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.deepPurpleAccent,
                              child: Text(
                                seriesTestMarkModel[index].rollNo,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            trailing: SizedBox(
                              width: 40,
                              height: 35,
                              child: TextFormField(
                                controller:
                                    seriesTestMarkModel[index].markController,
                                focusNode: seriesTestMarkModel[index].focusNode,
                                onFieldSubmitted: (value) {
                                  if (index + 1 != seriesTestMarkModel.length) {
                                    seriesTestMarkModel[index + 1]
                                        .focusNode
                                        .requestFocus();
                                  }
                                },
                                onChanged: (value) {
                                  if (value.length > 2) {
                                    seriesTestMarkModel[index]
                                        .markController
                                        .text = value.substring(0, 2);
                                    seriesTestMarkModel[index]
                                        .markController
                                        .selection = TextSelection.fromPosition(
                                      TextPosition(
                                          offset: seriesTestMarkModel[index]
                                              .markController
                                              .text
                                              .length),
                                    );
                                  }
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            title: Text(seriesTestMarkModel[index].name),
                          ),
                        );
                      },
                      itemCount: seriesTestMarkModel.length,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveSeriesTestData(BuildContext context) {
    if (_addAssignmentMarkFormKey.currentState!.validate()) {
      if (isAnyMarkFieldEmpty(seriesTestMarkModel)) {
        customAlertDialog(
            context: context,
            messageText:
                "Empty marks will be taken as '0'. Click Save to continue",
            onPrimaryButtonClick: () {
              addSeriesTestData(context);
              Navigator.of(context).pop();
            },
            secondButtonText: 'Cancel');
      } else {
        addSeriesTestData(context);
      }
    }
  }

  Future<void> addSeriesTestData(BuildContext context) async {
    final List<AddMarkModel> seriesTestMarksObjects = seriesTestMarkModel;
    final seriesTestMarksMaps = seriesTestMarksObjects.map((model) {
      return model.toMap();
    }).toList();

    try {
      final String docId = assignmentdata.dateCreated;
      await FirebaseFirestore.instance
          .collection('assignments')
          .doc(docId)
          .update({'submissions': seriesTestMarksMaps});
      showSnackBar(
          context: context,
          message: '  Mark added',
          icon: const Icon(
            Icons.done_outline,
            color: Colors.green,
          ));
    } catch (err) {
      sss(err);
      showSnackBar(
          context: context,
          message: '  Operation failed',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
    }
  }

  bool isAnyMarkFieldEmpty(List<AddMarkModel> list) {
    for (AddMarkModel model in list) {
      if (model.markController.text == '') {
        return true;
      }
    }
    return false;
  }
}
