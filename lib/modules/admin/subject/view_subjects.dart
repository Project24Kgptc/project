import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_analytics/modules/teacher/subject/subject_dash.dart';
import 'package:student_analytics/provider/subject_provider.dart';

class ViewSubjectRooms extends StatelessWidget {
  const ViewSubjectRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject Rooms'),),
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        children: [
          
          Expanded(child: Expanded(
          							child: Consumer<SubjectProvider>(
          								builder: (context, model, child) {
          									if(model.isLoading) {
          										return const Center(
          											child: CircularProgressIndicator(
          												color: Colors.white,
          											),
          										);
          									}
          									else if(model.subjects.isEmpty) {
          										return const Center(
          											child: Text('No data available'),
          										);
          									}
          									else {
          										return ListView.builder(
          											itemBuilder: (context, index) {
          												return Padding(
          													padding: const EdgeInsets.only(top: 3, left: 3, right: 3),
          													child: ListTile(
          														tileColor: Colors.deepOrangeAccent,
          														shape: RoundedRectangleBorder(
          															borderRadius: BorderRadius.circular(10)
          														),
          														contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          														leading: const Icon(Icons.subject),
          														title: Text(
          															model.subjects[index].subjectName,
          															style: const TextStyle(
          																fontWeight: FontWeight.w500,
          															),
          														),
          														subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
          														  children: [
          														    Text(model.subjects[index].batch),
                                          Text(model.subjects[index].teacherName),
                                          Text('Sem: '+model.subjects[index].semester),
          														  ],
          														),
          														trailing: Text(model.subjects[index].courseCode),
          														onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => TeacherSubjectDashboard(subjectModel: model.subjects[index]))),
          													),
          												);
          											},
          											itemCount: model.subjects.length,
          										);
          									} 
          								},
          							),
          						)),
        ],
      )
    );
  }
}