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
}