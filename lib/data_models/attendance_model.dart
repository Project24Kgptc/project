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
}