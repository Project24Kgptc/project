import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/assignment_model.dart';
import 'package:student_analytics/data_models/attendance_model.dart';
import 'package:student_analytics/data_models/seriestest_model.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/student/day_attentence.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class SubjectDashboard extends StatelessWidget {
  SubjectDashboard(
      {super.key,
      required this.subject,
      required this.studentdata,
      required this.totalAttentence});
  final SubjectModel subject;
  final StudentModel studentdata;
  final List<AttendanceModel> totalAttentence;
  int presentCount = 0;

  @override
  Widget build(BuildContext context) {
    for (var attendance in totalAttentence) {
      if (attendance.studentsList.contains(studentdata.rollNo)) {
        presentCount++;
      }
    }
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
                      value: percentage / 100,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        percentage.toString().length > 2
                            ? percentage.toString().substring(0, 4) + '%'
                            : percentage.toString() + '%',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w900),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DayAttentence(
                                        subject: subject.subjectName,
                                        attentenceList: totalAttentence,
                                      )));
                        },
                        icon: Icon(Icons.expand),
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
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: const Text('Assignments'),
                      children: const [
                        ListTile(
                          title: Center(child: CircularProgressIndicator()),
                        )
                      ],
                    );
                  } else if (!snapshot.hasData) {
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: const Text('Assignments'),
                      children: const [
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
                          model.submissions[i]['regNo'] == studentdata.regNo
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
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      title: const Text('Series Tests'),
                      children: const [
                        ListTile(
                          title: Center(child: CircularProgressIndicator()),
                        )
                      ],
                    );
                  } else if (!snapshot.hasData) {
                    return ExpansionTile(
                      title: const Text('Series Tests'),
                      collapsedBackgroundColor: Colors.deepPurpleAccent,
                      children: const [
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
                          model.marks[i]['regNo'] == studentdata.regNo
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
          .where('subjectId', isEqualTo: subject.subjectId)
          .get();
      if (data.docs.isNotEmpty) {
        final List<AssignmentModel> assignmentsList =
            data.docs.map((e) => (AssignmentModel.fromJson(e.data()))).toList();
        print(assignmentsList);
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
}
