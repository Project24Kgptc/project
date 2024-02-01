class AdminModel {

	final String name;
	final String email;

	const AdminModel({
		required this.name, 
		required this.email, 
	});

	Map<String, dynamic> toMap() {
		return {
			'name': name,
			'email': email,
		};
	}

	factory AdminModel.fromMaptoObject(Map<String, dynamic> map) {
		return AdminModel(
			name: map['name'],
			email: map['email'],
		);
	}
}