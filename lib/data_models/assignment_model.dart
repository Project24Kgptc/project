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

	factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      subjectId: json['subjectId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      submissions: (json['submissions'] as List<dynamic>? ?? []).map((submission) {
        // Assuming each submission is a Map<String, dynamic>
        return Map<String, dynamic>.from(submission);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'submissions': submissions,
	};
  }
}