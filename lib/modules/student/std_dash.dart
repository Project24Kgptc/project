// ignore_for_file: use_build_context_synchronously

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

  final double percentage;

  final ValueNotifier<String> _imageNotifier = ValueNotifier('');

  Future<void> pickImageFromGallery(context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
       

        final storage = FirebaseStorage.instance;
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = storage.ref().child('study_materials/$fileName');

        await storageRef.putFile(File(pickedFile.path));

        String downloadURL = await storageRef.getDownloadURL();
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('students')
            .doc(studentData.email);

        await documentReference.update({'profile': downloadURL});
        _imageNotifier.value = downloadURL;
        showSnackBar(
            context: context, message: 'Profile Updated', icon: const Icon(Icons.done));
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _imageNotifier.value = studentData.profile;
    return Scaffold(
      drawer: Drawer(
        backgroundColor:  Color(0xFFA95DE7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
              }, 
              child: Text(
                'Change Password   ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
            ))
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor:  Color(0xFFA95DE7),
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
        child: Container(
          height: double.infinity,
          			width: double.infinity,
					decoration: const BoxDecoration(
						image: DecorationImage(
							image: AssetImage('assets/background_images/bg.jpeg'),
							fit: BoxFit.cover
						),
						
					),
          child: Column(
           
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: InkWell(
                    onTap: () async {
                      await pickImageFromGallery(context);
                    },
                    child: ValueListenableBuilder<String>(
                      valueListenable: _imageNotifier,
                      builder: (context, image, _) {
                      if(image == '') {
                        return const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.deepPurpleAccent,
                          child: Icon(Icons.person, color: Colors.white,),
                        );
                      }
                      else {
                        return CircleAvatar(
                          radius: 25,
                          backgroundImage: 
                          NetworkImage(image),
                        );
                      }
                        
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
                      color:  Color(0xFFA95DE7),
                      backgroundColor: Colors.white,
                      value: (percentage / 100),
                    ),
                  ),
                  Text(
                    percentage.toString().length > 3
                        ? '${percentage.toString().substring(0,3)}%'
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
								margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
								padding: const EdgeInsets.all(10),
								decoration: BoxDecoration(
									color: Colors.white,
									borderRadius: BorderRadius.circular(10)
								),
								child: const Text(
									'Subjects',
									textAlign: TextAlign.center,
									style: TextStyle(
										fontSize: 20,
									),
								),
							),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
															decoration: BoxDecoration(
																color:  Color(0xFFA95DE7),
																borderRadius: BorderRadius.circular(10)
															),
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
																		fontWeight: FontWeight.w500,
																		color: Colors.white
																	),
																),
																subtitle: Text(
																	subjects[index].batch,
																	style: TextStyle(
																		color: Colors.white
																	),
																),
                                trailing: Text(
																	subjects[index].courseCode,
																	style: TextStyle(
																		color: Colors.white
																	),
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
