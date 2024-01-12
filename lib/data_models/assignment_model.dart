class AssignmentModel {
	final String subjectId;
	final String title;
	final String description;
	final String dueDate;
	final List<Map<String, dynamic>> submissions;

	AssignmentModel({
		required this.subjectId, 
		required this.title, 
		required this.description, 
		required this.dueDate, 
		required this.submissions
	});
}