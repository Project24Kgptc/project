class StudyMaterialModel {
final String name;
	final String subject;
	final String semester;
   final String downloadUrl;

	const StudyMaterialModel({
		required this.subject, 
		required this.semester, 
    required this.name, 
    required this.downloadUrl,
	});

	Map<String, dynamic> toMap() {
		return {
			'name': name,
      'subject':subject,
			'semester': semester,
      'downloadUrl':downloadUrl,
		};
	}

	factory StudyMaterialModel.fromMaptoObject(Map<String, dynamic> map) {
		return StudyMaterialModel(
			subject: map['subject'],
			semester: map['semester'],
      name: map['name'],
       downloadUrl: map['downloadUrl'],
		);
	}
}