import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_analytics/data_models/assignment_model.dart';
import 'package:student_analytics/data_models/attendance_model.dart';
import 'package:student_analytics/data_models/seriestest_model.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/study_materials.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/student/day_attentence.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SubjectDashboard extends StatelessWidget {
  SubjectDashboard(
      {super.key,
      required this.subject,
      required this.studentData,
      required this.totalAttentence})
      : presentCount = getPresentCount(totalAttentence, studentData);

  final SubjectModel subject;
  final StudentModel studentData;
  final List<AttendanceModel> totalAttentence;
  final int presentCount;

  @override
  Widget build(BuildContext context) {
    // for (var attendance in totalAttentence) {
    //   if(attendance.studentsList.contains(studentData.rollNo)){
    //     presentCount++;
    //   }
    // }
    double percentage = (presentCount / totalAttentence.length) * 100;
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.subjectName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, spreadRadius: 0, offset: Offset(-2, 2))
                    ]),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: Text(
                    subject.subjectName,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    subject.courseCode,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      color: Colors.deepPurpleAccent,
                      backgroundColor: Colors.grey,
                      value: 0.1,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        percentage.toString().length > 3
                            ? '${percentage.toString().substring(0, 3)}%'
                            : '$percentage%',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w900),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DayAttentence(
                                      subject: subject.subjectName,
                                      attentenceList: totalAttentence)));
                        },
                        icon: const Icon(Icons.expand),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              FutureBuilder(
                future: getAssignments(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: Text('Assignments'),
                      children: [
                        ListTile(
                          title: Center(child: CircularProgressIndicator()),
                        )
                      ],
                    );
                  } else if (!snapshot.hasData) {
                    return const ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: Text('Assignments'),
                      children: [
                        ListTile(
                          title: Text('No data'),
                        )
                      ],
                    );
                  } else {
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: const Text('Assignments'),
                      children: snapshot.data!.map((model) {
                        String mark = '0';
                        for (var i = 0; i < model.submissions.length; i++) {
                          model.submissions[i]['regNo'] == studentData.regNo
                              ? mark = model.submissions[i]['mark']
                              : '0';
                        }

                        return ListTile(
                          title: Text(model.title),
                          subtitle: Text(model.description),
                          trailing: Column(
                            children: [
                              Text(model.dueDate),
                              Text(mark),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 2,
              ),
              FutureBuilder(
                future: getSeriesTests(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: Text('Series Tests'),
                      children: [
                        ListTile(
                          title: Center(child: CircularProgressIndicator()),
                        )
                      ],
                    );
                  } else if (!snapshot.hasData) {
                    return const ExpansionTile(
                      title: Text('Series Tests'),
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      children: [
                        ListTile(
                          title: Text('No data'),
                        )
                      ],
                    );
                  } else {
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: const Text('Series Tests'),
                      children: snapshot.data!.map((model) {
                        String mark = '0';
                        for (var i = 0; i < model.marks.length; i++) {
                          model.marks[i]['regNo'] == studentData.regNo
                              ? mark = model.marks[i]['mark']
                              : '0';
                        }
                        return ListTile(
                          title: Text(model.title),
                          subtitle: Text(model.subjectName),
                          trailing: Text(mark.toString()),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 2,
              ),
              FutureBuilder(
                future: listData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: Text('Study Materials'),
                      children: [
                        ListTile(
                          title: Center(child: CircularProgressIndicator()),
                        )
                      ],
                    );
                  } else if (!snapshot.hasData) {
                    return const ExpansionTile(
                      title: Text('Study Materials'),
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      children: [
                        ListTile(
                          title: Text('No data'),
                        )
                      ],
                    );
                  } else {
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: const Text('Study Materials'),
                      children: snapshot.data!.map((model) {
                        return ListTile(
                          title: Text(model.name),
                          leading: Icon(
                            Icons.file_present,
                            color: Colors.red,
                          ),
                          trailing: IconButton(
                              onPressed: () async {
                                await downloadFile( context,model.name);
                              },
                              icon: Icon(Icons.download)),
                        );
                      }).toList(),
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

  Future<void> downloadFile(BuildContext ctx,String s) async 
    {
		if(await Permission.storage.isDenied) {
			await Permission.storage.request();
		}
		if(await Permission.storage.isDenied) {
			// showMessage(ctx, "   Permission Denied", const Icon(Icons.cancel, color: Color(0xFFFF0000),));
			return;
		}
		const dir = "/storage/emulated/0/Cloud Files";
		await Directory(dir).create();
		File file = File("/storage/emulated/0/Cloud Files/$s");

        final ref = FirebaseStorage.instance.ref().child("/$s");
		final task = ref.writeToFile(file);
		task.whenComplete(() {
			showSnackBar(context: ctx, message: "   Download Completed", icon: const Icon(Icons.download));
		});
    }

  Future<List<AssignmentModel>?> getAssignments(BuildContext context) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('assignments')
          .where('subjectId', isEqualTo: subject.subjectId)
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
          .where('subjectId', isEqualTo: subject.subjectId)
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

  static int getPresentCount(
      List<AttendanceModel> attentencelist, StudentModel studentData) {
    int presentCount = attentencelist.fold(
      0,
      (count, attendance) =>
          count +
          (attendance.studentsList.contains(studentData.rollNo) ? 1 : 0),
    );

    return presentCount;
  }


  Future<List> listData() async
	{
		List l = [];
		l.clear();

		final cc = await FirebaseStorage.instance.ref().child('folder/').list();

		for (var e in cc.items) {
			l.add(e.name);
		}
		return l;
	}

   
//   Future<List<StudyMaterialModel>?> getStudyMaterials(
//       BuildContext context) async {
//     try {
//       final data = await FirebaseFirestore.instance
//           .collection('study_materials')
//           .where('subject', isEqualTo: subject.subjectName)
//           .get();
//       if (data.docs.isNotEmpty) {
//         final List<StudyMaterialModel> studyMaterialList = data.docs
//             .map((e) => (StudyMaterialModel.fromMaptoObject(e.data())))
//             .toList();
//         return studyMaterialList;
//       } else {
//         return null;
//       }
//     } catch (err) {
//       sss(err);
//       showSnackBar(
//           context: context,
//           message: '  Error occured !',
//           icon: const Icon(
//             Icons.error,
//             color: Colors.red,
//           ));
//       return null;
//     }
//   }
}
