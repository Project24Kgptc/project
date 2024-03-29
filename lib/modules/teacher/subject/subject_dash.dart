// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/assignment_model.dart';
import 'package:student_analytics/data_models/attendance_model.dart';
import 'package:student_analytics/data_models/seriestest_mark_model.dart';
import 'package:student_analytics/data_models/seriestest_model.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/study_materials.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/teacher/subject/add_assignment/ad_markAss.dart';
import 'package:student_analytics/modules/teacher/subject/add_assignment/add_assignment.dart';
import 'package:student_analytics/modules/teacher/subject/add_attendance/add_attentence.dart';
import 'package:student_analytics/modules/teacher/subject/add_seriestest/add_seriestest.dart';
import 'package:student_analytics/modules/teacher/subject/add_studyMaterial/add_stdyMaterial.dart';
import 'package:student_analytics/widgets/alert_dialog.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class TeacherSubjectDashboard extends StatelessWidget {
  const TeacherSubjectDashboard({super.key, required this.subjectModel});

  final SubjectModel subjectModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA95DE7),
        title: Text(subjectModel.subjectName),
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
          child: ListView(
            children: [
              const SizedBox(height: 20,),
              FutureBuilder(
                future: getAssignments(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Assignments', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => AddAssignmentScreen(
                                      subjectId: subjectModel.subjectId))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Assignments', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => AddAssignmentScreen(
                                      subjectId: subjectModel.subjectId))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Text('No data'),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Assignments', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => AddAssignmentScreen(
                                      subjectId: subjectModel.subjectId))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: snapshot.data!.map((model) {
                          return ListTile(
                            title: Text(model.title),
                            subtitle: Text(model.description),
                            trailing: Text(model.dueDate),
                            onTap: () async {
                              List<AddMarkModel>? markModel =
                                  await generateSeriestestModel();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAssignmentMark(
                                            assignmentdata: model,
                                            subjectModel: subjectModel,
                                            seriesTestMarkModel:
                                                markModel!.toList(),
                                          )));
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                future: getSeriesTests(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Series Tests', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () => gotoAddSeriesTestScreen(context),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Series Tests', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () => gotoAddSeriesTestScreen(context),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Text('No data'),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Series Tests', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () => gotoAddSeriesTestScreen(context),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: snapshot.data!.map((model) {
                          return ListTile(
                            title: Text(model.title),
                            subtitle: Text(model.subjectName),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                future: getAttentence(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Attendances', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => AddAttendanceScreen(
                                        batch: subjectModel.batch,
                                        subjectId: subjectModel.subjectId,
                                        subjectName: subjectModel.subjectName,
                                        teacherName: subjectModel.teacherName,
                                      ))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Attendances', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => AddAttendanceScreen(
                                        batch: subjectModel.batch,
                                        subjectId: subjectModel.subjectId,
                                        subjectName: subjectModel.subjectName,
                                        teacherName: subjectModel.teacherName,
                                      ))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Text('No data'),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Attendances'),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => AddAttendanceScreen(
                                        batch: subjectModel.batch,
                                        subjectId: subjectModel.subjectId,
                                        subjectName: subjectModel.subjectName,
                                        teacherName: subjectModel.teacherName,
                                      ))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: snapshot.data!.map((model) {
                          return ListTile(
                            title: Text(model.date.toString().substring(0, 10)),
                            subtitle: Text(model.hour),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              //StudyMaterials
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                future: getStudyMaterials(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Study Materials', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => AddStudyMaterials(
                                    subId: subjectModel.subjectId,
                                        semester: subjectModel.semester,
                                        subject: subjectModel.subjectName,
                                      ))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Study Materials', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => AddStudyMaterials(
                                     subId: subjectModel.subjectId,
                                        semester: subjectModel.semester,
                                        subject: subjectModel.subjectName,
                                      ))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: const [
                          ListTile(
                            title: Text('No data'),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: ExpansionTile(
                        title: const Text('Study Materials', style: TextStyle(color: Colors.white),),
                        collapsedBackgroundColor: const Color(0xFFA95DE7),
                        trailing: IconButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => AddStudyMaterials(
                                     subId: subjectModel.subjectId,
                                        semester: subjectModel.semester,
                                        subject: subjectModel.subjectName,
                                      ))),
                          icon: const Icon(Icons.add, color: Colors.white,),
                        ),
                        children: snapshot.data!.map((model) {
                          return ListTile(
                            title: Text(model.name.toString()),
                            subtitle: Text(model.semester),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<AssignmentModel>?> getAssignments(BuildContext context) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('assignments')
          .where('subjectId', isEqualTo: subjectModel.subjectId)
          .get();
      if (data.docs.isNotEmpty) {
        final List<AssignmentModel> assignmentsList =
            data.docs.map((e) => (AssignmentModel.fromJson(e.data()))).toList();
        return assignmentsList;
      } else {
        return null;
      }
    } catch (err) {
      sss(err);
      showSnackBar(
          context: context,
          message: '  Error occured !',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
      return null;
    }
  }

  Future<List<SeriesTestModel>?> getSeriesTests(BuildContext context) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('seriesTests')
          .where('subjectId', isEqualTo: subjectModel.subjectId)
          .get();
      if (data.docs.isNotEmpty) {
        final List<SeriesTestModel> seriesTestsList =
            data.docs.map((seriesTest) {
          return SeriesTestModel.fromMaptoObject(seriesTest.data());
        }).toList();
        return seriesTestsList;
      } else {
        return null;
      }
    } catch (err) {
      sss(err);
      showSnackBar(
          context: context,
          message: '  Error occured !',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
      return null;
    }
  }

  Future<List<AddMarkModel>?> generateSeriestestModel() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> students =
          await FirebaseFirestore.instance
              .collection('students')
              .where('batch', isEqualTo: subjectModel.batch)
              .get();

      if (students.docs.isNotEmpty) {
        final List<StudentModel> studentsListModel = students.docs.map((map) {
          return StudentModel.fromMaptoObject(map.data());
        }).toList();

        final List<AddMarkModel> studensSeriestestList =
            studentsListModel.map((model) {
          final FocusNode focusNode = FocusNode();
          return AddMarkModel(
              name: model.name,
              rollNo: model.rollNo,
              regNo: model.regNo,
              focusNode: focusNode,
              markController: TextEditingController());
        }).toList();

        return studensSeriestestList;
      } else {
        return null;
      }
    } catch (err) {
      sss(err);
      return null;
    }
  }

  Future<void> gotoAddSeriesTestScreen(BuildContext context) async {
    final List<AddMarkModel>? seriesTestMarksModel =
        await generateSeriestestModel();
    if (seriesTestMarksModel != null && seriesTestMarksModel.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => AddSeriesTest(
                subjectModel: subjectModel,
                seriesTestMarkModel: seriesTestMarksModel,
              )));
    } else {
      customAlertDialog(
          context: context,
          messageText: 'No students data found for the subject !',
          onPrimaryButtonClick: () => Navigator.of(context).pop(),
          isSecondButtonVisible: false,
          primaryButtonText: 'Back');
    }
  }

  Future<List<AttendanceModel>?> getAttentence(BuildContext context) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('attentence')
          .where('subjectId', isEqualTo: subjectModel.subjectId)
          .get();
      if (data.docs.isNotEmpty) {
        final List<AttendanceModel> attentenceList =
            data.docs.map((e) => (AttendanceModel.fromMap(e.data()))).toList();
        return attentenceList;
      } else {
        return null;
      }
    } catch (err) {
      sss(err);
      showSnackBar(
          context: context,
          message: '  Error occured !',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
      return null;
    }
  }

  //get Study Materials
  Future<List<StudyMaterialModel>?> getStudyMaterials(
      BuildContext context) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('study_materials')
          .where('subject', isEqualTo: subjectModel.subjectName)
          .get();
      if (data.docs.isNotEmpty) {
        final List<StudyMaterialModel> studyMaterialList = data.docs
            .map((e) => (StudyMaterialModel.fromMaptoObject(e.data())))
            .toList();
        return studyMaterialList;
      } else {
        return null;
      }
    } catch (err) {
      sss(err);
      showSnackBar(
          context: context,
          message: '  Error occured !',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
      return null;
    }
  }
}
