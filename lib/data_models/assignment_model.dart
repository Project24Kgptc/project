class AssignmentModel {
	final String subjectId;
	final String title;
	final String description;
	final String dueDate;
	final String dateCreated;
	final List<Map<String, dynamic>> submissions;

	AssignmentModel({
		required this.dateCreated,
		required this.subjectId, 
		required this.title, 
		required this.description, 
		required this.dueDate, 
		required this.submissions
	});

	factory AssignmentModel.fromJson(Map<String, dynamic> map) {
		return AssignmentModel(
			subjectId: map['subjectId'],
			title: map['title'],
			description: map['description'],
			dueDate: map['dueDate'],
			dateCreated: map['dateCreated'],
			submissions: (map['submissions'] as List<dynamic>? ?? []).map((submission) {
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
			'dateCreated': dateCreated,
			'submissions': submissions,
		};
	}
}

