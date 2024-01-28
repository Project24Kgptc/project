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

	// factory SeriesTestModel.fromMaptoObject(List<StudentModel> studentModels, SubjectModel subjectModel, String title) {
	// 	return SeriesTestModel(
	// 		title: title,
	// 		subjectId: subjectModel.subjectId,
	// 		subjectName: subjectModel.subjectName,
	// 		marks: studentModels.map((model) {
	// 			return {
	// 				'rollNo': model.rollNo,
	// 				'regNo': model.regNo,
	// 				'studentName': model.name,
	// 				'mark': ''
	// 			};
	// 		}).toList()
	// 	);
	// }

	Map<String, dynamic> toMap() {
		return {
			'subjectId': subjectId,
			'title': title,
			'subjectName': subjectName,
			'marks': marks
		};
	}
}