import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/data_models/admin_model.dart';
import 'package:student_analytics/modules/admin/admin_dash.dart';
import 'package:student_analytics/modules/admin/students/add_student/add_student.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/provider/batch_provider.dart';
import 'package:student_analytics/provider/students_provider.dart';

ValueNotifier<String?> dropdownNotifier = ValueNotifier('--- All ---');

class AdminAllStudentsPage extends StatelessWidget {
  const AdminAllStudentsPage({super.key, required this.admin});
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
          title: const Text('Students'),
          actions: [
            Consumer<StudentsBatchProvider>(
              builder: (context, model, child) {
                return ValueListenableBuilder(
                  valueListenable: dropdownNotifier,
                  builder: (context, value, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButton<String>(
                          dropdownColor: Colors.deepPurpleAccent,
                          icon: const Icon(Icons.keyboard_arrow_down_sharp),
                          iconEnabledColor: Colors.white,
                          value: value,
                          onChanged: (String? value) {
                            dropdownNotifier.value = value;
                            Provider.of<StudentsProvider>(context,
                                    listen: false)
                                .setFilteredStudent(value ?? '--- All ---');
                          },
                          items: model.batches),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => AddStudent())),
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
        body: SafeArea(child: Consumer<StudentsProvider>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (model.filteredStudents.isEmpty) {
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
                      leading: model.students[index].profile == '' ? const CircleAvatar(
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Icon(Icons.person, color: Colors.white,),
                      ) : CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(model.students[index].profile),
                      ),
                      title: Text(
                        model.filteredStudents[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(model.filteredStudents[index].batch),
                      onTap: () => showMyBottomSheet(
                          context, model.filteredStudents[index]),
                    ),
                  );
                },
                itemCount: model.filteredStudents.length,
              );
            }
          },
        )),
      ),
    );
  }

  void showMyBottomSheet(BuildContext context, StudentModel student) {
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
                        Provider.of<StudentsProvider>(context, listen: false)
                            .deleteStudent(context, student.email);
                        navigateToStudentsPage(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      )),
                ),
                student.profile == '' ? const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ) : CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(student.profile),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  student.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(student.regNo),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        });
  }

  Future<void> navigateToStudentsPage(BuildContext context) async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) =>  AdminAllStudentsPage(admin: admin,)));
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
}
