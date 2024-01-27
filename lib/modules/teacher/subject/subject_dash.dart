import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/subject_model.dart';
import 'package:student_analytics/modules/teacher/subject/add_assignment/add_assignment.dart';
import 'package:student_analytics/modules/teacher/subject/add_attendance/add_attentence.dart';

class SubjectDashboard extends StatelessWidget {
	const SubjectDashboard({super.key, required this.subjectModel});

	final SubjectModel subjectModel;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(subjectModel.subjectName),
			),
			body: SafeArea(
				child: Column(
					children: [
						ExpansionTile(
							collapsedBackgroundColor: Colors.deepOrangeAccent,
							title: Text('Assignments'),
							trailing: IconButton(
								onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddAssignmentScreen(subjectId: subjectModel.subjectId))),
								icon: Icon(Icons.add),
							),
							children: [
								Text('Assignment1'),
								Text('Assignment1'),
								Text('Assignment1'),
							],
						),
						SizedBox(height: 5,),
						ExpansionTile(
							collapsedBackgroundColor: Colors.deepOrangeAccent,
							title: Text('Series Tests'),
							trailing: IconButton(
								onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddAttendanceScreen(batch: subjectModel.batch, subjectId: subjectModel.subjectId, subjectName: subjectModel.subjectName, teacherName: subjectModel.teacherName,))),
								icon: Icon(Icons.add),
							),
							children: [
								Text('SeriesTest'),
								Text('SeriesTest'),
								Text('SeriesTest'),
							],
						),
						SizedBox(height: 5,),
						ExpansionTile(
							collapsedBackgroundColor: Colors.deepOrangeAccent,
							title: Text('Attendances'),
							trailing: IconButton(
								onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddAttendanceScreen(batch: subjectModel.batch, subjectId: subjectModel.subjectId, subjectName: subjectModel.subjectName, teacherName: subjectModel.teacherName,))),
								icon: Icon(Icons.add),
							),
							children: [
								Text('Attendance1'),
								Text('Attendance1'),
								Text('Attendance1'),
							],
						),
					],
				),
			),
		);
	}
}