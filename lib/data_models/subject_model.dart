class SubjectModel {

	final String subjectId;
	final String teacherId;
	final String teacherName;
	final String courseCode;
	final String semester;
	final String subjectName;
	final String batch;

	SubjectModel({
		required this.subjectId,  
		required this.teacherId,  
		required this.teacherName, 
		required this.courseCode, 
		required this.semester, 
		required this.subjectName,
		required this.batch
	});

	factory SubjectModel.fromMaptoObject(Map<String, dynamic> map) {
		return SubjectModel(
			subjectId: map['subjectId'],
			teacherId: map['teacherId'],
			teacherName: map['teacherName'],
			courseCode: map['courseCode'],
			semester: map['semester'],
			subjectName: map['subjectName'],
			batch: map['batch'],
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'subjectId': subjectId,
			'teacherId': teacherId,
			'teacherName': teacherName,
			'courseCode': courseCode,
			'semester': semester,
			'subjectName': subjectName,
			'batch': batch
		};
	}
}