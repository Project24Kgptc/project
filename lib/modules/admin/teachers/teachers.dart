import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/admin_model.dart';
import 'package:student_analytics/modules/admin/admin_dash.dart';
import 'package:student_analytics/modules/admin/teachers/add_teacher/add_teacher.dart';
import 'package:student_analytics/data_models/teacher_model.dart';
import 'package:student_analytics/provider/teachers_provider.dart';

class AdminAllTeachersPage extends StatelessWidget {
  const AdminAllTeachersPage({super.key, required this.admin});
  final AdminModel admin;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminDashboard(adminModel: admin)));
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text('Teachers'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => AddTeacher())),
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurpleAccent),
                    side: MaterialStatePropertyAll(
                        BorderSide(color: Colors.white)),
                    shadowColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Add'),
              ),
            ),
          ],
        ),
        body: SafeArea(child: Consumer<TeachersProvider>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (model.teachers.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 3, left: 3, right: 3),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        model.teachers[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () =>
                          showMyBottomSheet(context, model.teachers[index]),
                    ),
                  );
                },
                itemCount: model.teachers.length,
              );
            }
          },
        )),
      ),
    );
  }

  void showMyBottomSheet(BuildContext context, TeacherModel teacher) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        showDragHandle: true,
        backgroundColor: Colors.deepPurpleAccent,
        context: context,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        Provider.of<TeachersProvider>(context, listen: false)
                            .deleteStudent(
                                teacher.email.replaceAll('@mail.com', ''),
                                context);

                        navigateToTeachersPage(context);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      )),
                ),
                const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  teacher.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(teacher.email),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        });
  }

  Future<void> navigateToTeachersPage(BuildContext context) async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) =>  AdminAllTeachersPage(admin: admin,)));
    final teachers =
        await FirebaseFirestore.instance.collection('teachers').get();
    await Future.delayed(const Duration(microseconds: 100));
    final List<TeacherModel> teacherObjectsList = teachers.docs
        .map((student) => TeacherModel.fromMaptoObject(student.data()))
        .toList();
    Provider.of<TeachersProvider>(context, listen: false)
        .setAllTeachersData(teacherObjectsList);
  }
}
