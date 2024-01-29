import 'package:student_analytics/data_models/seriestest_mark_model.dart';

class SeriesTestModel {
	final String subjectId;
	final String title;
	final String subjectName;
	final List<Map<String, dynamic>> marks;

	SeriesTestModel({
		required this.subjectId, 
		required this.title, 
		required this.subjectName, 
		required this.marks
	});

	factory SeriesTestModel.fromMaptoObject(Map<String, dynamic> map) {
		final List<Map<String, dynamic>> castedMarks = (map['marks'] as List<dynamic>).map((markData) => Map<String, dynamic>.from(markData)).toList();
		return SeriesTestModel(
			title: map['title'],
			subjectId: map['subjectId'],
			subjectName: map['subjectName'],
			marks: castedMarks.map((markData) {
				return {
					'rollNo': markData['rollNo'],
					'regNo': markData['regNo'],
					'studentName': markData['studentName'],
					'mark': markData['mark']
				};
			}).toList()
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'subjectId': subjectId,
			'title': title,
			'subjectName': subjectName,
			'marks': marks
		};
	}
}