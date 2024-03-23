// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/admin_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/modules/admin/students/students.dart';
import 'package:student_analytics/modules/admin/subject/view_subjects.dart';
import 'package:student_analytics/modules/admin/teachers/teachers.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/provider/batch_provider.dart';
import 'package:student_analytics/provider/students_provider.dart';
import 'package:student_analytics/provider/subject_provider.dart';
import 'package:student_analytics/provider/teachers_provider.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

ValueNotifier buttonLoadingNotifier = ValueNotifier(false);

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key, required this.adminModel});

  final AdminModel adminModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ]),
                  child: ListTile(
                    title: Text(
                      adminModel.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    subtitle: Text(
                      adminModel.email,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () => logout(context),
                      icon: const Icon(
                        Icons.login_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )),
              InkWell(
                onTap: () {
                  getSubjects(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewSubjectRooms()));
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ]),
                  child: Center(
                    child: Text('View SubjectRooms'),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () => navigateToStudentsPage(context),
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10, right: 5),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'Students',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () => navigateToTeachersPage(context),
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 5, top: 10, bottom: 10, right: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'Teachers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateToStudentsPage(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => AdminAllStudentsPage(
              admin: adminModel,
            )));
    final students =
        await FirebaseFirestore.instance.collection('students').get();
    await Future.delayed(const Duration(microseconds: 100));
    final List<StudentModel> studentObjectsList = students.docs
        .map((student) => StudentModel.fromMaptoObject(student.data()))
        .toList();

    List<String> batchList = [];
    for (var student in studentObjectsList) {
      if (!batchList.contains(student.batch)) {
        batchList.add(student.batch);
      }
    }
    batchList.sort();

    Provider.of<StudentsProvider>(context, listen: false)
        .setAllStudentsData(studentObjectsList);
    dropdownNotifier.value = '--- All ---';
    Provider.of<StudentsBatchProvider>(context, listen: false)
        .setBatches(batchList);
  }

  Future<void> navigateToTeachersPage(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => AdminAllTeachersPage(
              admin: adminModel,
            )));
    final teachers =
        await FirebaseFirestore.instance.collection('teachers').get();
    await Future.delayed(const Duration(microseconds: 100));
    final List<TeacherModel> teacherObjectsList = teachers.docs
        .map((student) => TeacherModel.fromMaptoObject(student.data()))
        .toList();
    Provider.of<TeachersProvider>(context, listen: false)
        .setAllTeachersData(teacherObjectsList);
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => LoginPage()));
    } catch (err) {
      showSnackBar(
          context: context,
          message: '  Error occured !',
          icon: const Icon(
            Icons.error_sharp,
            color: Colors.red,
          ),
          duration: 3);
    }
  }

  Future<List<SubjectModel>> getSubjects(context) async {
    try {
      final subjects =
          await FirebaseFirestore.instance.collection('subjects').get();
      await Future.delayed(const Duration(microseconds: 100));
      final List<SubjectModel> subjectObjectsList = subjects.docs
          .map((subject) => SubjectModel.fromMaptoObject(subject.data()))
          .toList();
      Provider.of<SubjectProvider>(context, listen: false)
          .setAllSubjectsData(subjectObjectsList);

      return subjectObjectsList;
    } catch (e) {
      print('Error getting data from collection: $e');
      return [];
    }
  }
}
