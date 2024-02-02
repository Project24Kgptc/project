import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/assignment_model.dart';
import 'package:student_analytics/data_models/seriestest_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class SubjectDashboard extends StatelessWidget {
  SubjectDashboard({super.key, required this.subject});
  final SubjectModel subject;

  // final Map<String, dynamic> subject = {
  //   'name': "Internet of Things",
  //   'code': '5131'
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.subjectName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 2, spreadRadius: 0, offset: Offset(-2, 2))
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
                    value: 0.75,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${0.75 * 100}%',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                    IconButton(
                      onPressed: () {},
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
                      return ListTile(
                        title: Text(model.title),
                        subtitle: Text(model.description),
                        trailing: Text(model.dueDate),
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
                      return ListTile(
                        title: Text(model.title),
                        subtitle: Text(model.subjectName),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
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
