// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_analytics/auth/login_page.dart';
import 'package:student_analytics/data_models/attendance_model.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/main.dart';
import 'package:student_analytics/modules/student/changePassword.dart';
import 'package:student_analytics/modules/student/subject_dash.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard(
      {super.key,
      required this.studentData,
      required this.subjects,
      required this.attentencelist,
      this.profileurl})
      : percentage = getPresentCount(attentencelist, studentData);

  final StudentModel studentData;
  final List<SubjectModel> subjects;
  final List<AttendanceModel> attentencelist;
  final String? profileurl;
  String downloadURL = '';

  final double percentage;

  final ValueNotifier<File?> _imageNotifier = ValueNotifier(null);

  Future<void> pickImageFromGallery(context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageNotifier.value = File(pickedFile.path);

        final storage = FirebaseStorage.instance;
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = storage.ref().child('study_materials/$fileName');

        await storageRef.putFile(File(pickedFile.path));

        downloadURL = await storageRef.getDownloadURL();
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('students')
            .doc(studentData.email);

        await documentReference.update({'profile': downloadURL});
        showSnackBar(
            context: context, message: 'Profile Updated', icon: SizedBox());
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ImageProvider foregroundImage;

    // if (_imageNotifier.value == null) {
    //   foregroundImage = NetworkImage('url');
    // } else {
    //   foregroundImage = FileImage(_imageNotifier.value!);
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => LoginPage()));
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
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
         
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                },
                child: Text('Change Password    ',
                    style: TextStyle(color: Colors.blue)),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 2, spreadRadius: 0, offset: Offset(-2, 2))
              ]),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: InkWell(
                  onTap: () async {
                    await pickImageFromGallery(context);
                  },
                  child: ValueListenableBuilder<File?>(
                    valueListenable: _imageNotifier,
                    builder: (context, image, _) {
                      return CircleAvatar(
                        // foregroundImage: foregroundImage,
                        radius: 25,
                        backgroundColor: Colors.deepPurpleAccent,
                        // foregroundImage: NetworkImage(''),
                        backgroundImage: image != null
                            ? FileImage(image) as ImageProvider<Object>?
                            : NetworkImage(studentData.profile),
                      );
                    },
                  ),
                ),
                title: Text(
                  studentData.name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  studentData.regNo,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                trailing: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rank',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.black,
                      child: Text(
                        '65',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
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
                    value: (percentage / 100),
                  ),
                ),
                Text(
                  percentage.toString().length > 2
                      ? '${percentage.toString().substring(0, 3)}%'
                      : '$percentage%',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w900),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.purple, borderRadius: BorderRadius.circular(5)),
              child: const Text(
                'Subjects',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        onTap: () async {
                          List<AttendanceModel> attentence =
                              await getSubjAttendance(
                                  subjects[index].subjectId);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SubjectDashboard(
                              totalAttentence: attentence,
                              subject: subjects[index],
                              studentData: studentData,
                            ),
                          ));
                        },
                        title: Text(
                          subjects[index].subjectName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ));
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 3,
                ),
                itemCount: subjects.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<AttendanceModel>> getSubjAttendance(String subId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attentence')
          .where('subjectId', isEqualTo: subId)
          .get();

      List<AttendanceModel> attendance = querySnapshot.docs
          .map((DocumentSnapshot document) =>
              AttendanceModel.fromMap(document.data() as Map<String, dynamic>))
          .toList();

      return attendance;
    } catch (e) {
      sss('error: $e');
      rethrow;
    }
  }

  static double getPresentCount(
      List<AttendanceModel> attentencelist, StudentModel studentData) {
    final int presentCount = attentencelist.fold(
      0,
      (count, attendance) =>
          count +
          (attendance.studentsList.contains(studentData.rollNo) ? 1 : 0),
    );
    final double percantage =
        (presentCount / (attentencelist.isEmpty ? 1 : attentencelist.length)) *
            100;
    return percantage;
  }
}
