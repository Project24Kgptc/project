import 'package:student_analytics/data_models/attendance_model.dart';
import 'package:student_analytics/data_models/student_model.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/provider/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAttendanceScreen extends StatefulWidget {
  const AddAttendanceScreen({
		super.key,
      required this.batch,
      required this.subjectId,
      required this.subjectName,
      required this.teacherName, });
  final String batch;
  final String subjectId;
  final String subjectName;
  final String teacherName;
  @override
  _AddAttendanceScreenState createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  List<String> checkedRoll = [];
  List<StudentModel> studentList = [];
  List<bool> checkedStudents = List.generate(5, (index) => false);
  String selectedHour = 'Select Hour';
  List<String> hourList = [
    'Select Hour',
    'Hour 1',
    'Hour 2',
    'Hour 3',
    'Hour 4',
    'Hour 5',
    'Hour 6'
  ];

  void addCheckedStudents() {
    checkedRoll.clear();
    for (int i = 0; i < studentList.length; i++) {
      if (checkedStudents[i]) {
        checkedRoll.add(studentList[i].rollNo);
      }
    }
    print('Checked Students: $checkedRoll');
    // You can perform additional actions with the checkedNames list.
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    var provider = Provider.of<AttendanceProvider>(context, listen: false);
    studentList = await provider.getStudentsbyBatch(widget.batch);
    setState(() {});
    print(studentList.length);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AttendanceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
        actions: [
          DropdownButton<String>(
            elevation: 0,
            hint: Text('Select Hour'),
            value: selectedHour,
            onChanged: (String? newValue) {
              setState(() {
                selectedHour = newValue!;
              });
            },
            items: hourList.map((String hour) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: hour,
                child: Text(hour),
              );
            }).toList(),
          ),
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: studentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(studentList[index].name),
                        subtitle: Text(studentList[index].rollNo),
                        trailing: Checkbox(
                          value: checkedStudents[index],
                          onChanged: (bool? value) {
                            setState(() {
                              checkedStudents[index] = value ?? false;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addCheckedStudents();
                 provider. addAttentence(
                      AttendanceModel(
                        subjectId: widget.subjectId,
                        teacherName: widget.teacherName,
                        studentsList: checkedRoll,
                        subjectName: widget.subjectName,
                        date: DateTime.now().toString(),
                        hour: selectedHour,
                      ),
                      context);
                },
                child: Text('Add Attentence'),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
