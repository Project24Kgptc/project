class AttendanceModel {

	final String subjectId;
	final String subjectName;
	final String teacherName;
	final List<String> studentsList;
	final String date;
	final String hour;

	AttendanceModel({
		required this.subjectId, 
		required this.teacherName, 
		required this.studentsList,
		required this.subjectName, 
		required this.date, 
		required this.hour
	});

	 // Named constructor for creating an instance from a map
  AttendanceModel.fromMap(Map<String, dynamic> map)
      : subjectId = map['subjectId'] ?? '',
        teacherName = map['teacherName'] ?? '',
        studentsList = (map['studentsList'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        subjectName = map['subjectName'] ?? '',
        date = map['date'] ?? '',
        hour = map['hour'] ?? '';

  	Map<String, dynamic> toMap() {
    	return {
    	  'subjectId': subjectId,
    	  'teacherName': teacherName,
    	  'studentsList': studentsList,
    	  'subjectName': subjectName,
    	  'date': date,
    	  'hour': hour,
    	};
	}

}