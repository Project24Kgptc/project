class TeacherModel {

	final String teacherId;
	final String name;
	final String email;
	final String phoneNumber;

	const TeacherModel({
		required this.teacherId, 
		required this.name, 
		required this.email, 
		required this.phoneNumber
	});

	Map<String, dynamic> toMap() {
		return {
			'teacherId': teacherId,
			'name': name,
			'email': email,
			'phoneNumber': phoneNumber,
		};
	}

	factory TeacherModel.fromMaptoObject(Map<String, dynamic> map) {
		return TeacherModel(
			teacherId: map['teacherId'],
			name: map['name'],
			email: map['email'],
			phoneNumber: map['phoneNumber'],
		);
	}
}