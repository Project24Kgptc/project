class StudentModel {
  final String name;
  final String email;
  final String regNo;
  final String rollNo;
  final String phoneNumber;
  final String batch;
  final String rank;
  final List<String> subjects;
  final String profile;

  StudentModel(
      {required this.name,
      required this.email,
      required this.regNo,
      required this.rollNo,
      required this.phoneNumber,
      required this.batch,
      required this.rank,
      required this.profile,
      required this.subjects});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'regNo': regNo,
      'rollNo': rollNo,
      'phoneNumber': phoneNumber,
      'batch': batch,
      'rank': rank,
      'subjects': subjects,
      'profile':profile,
    };
  }

  factory StudentModel.fromMaptoObject(Map<String, dynamic> map) {
    return StudentModel(
        name: map['name'],
        email: map['email'],
        regNo: map['regNo'],
        rollNo: map['rollNo'],
        phoneNumber: map['phoneNumber'],
        batch: map['batch'],
        rank: map['rank'],
        profile:map['profile'],
        subjects: (map['subjects'] as List<dynamic>).cast<String>());
  }
}
