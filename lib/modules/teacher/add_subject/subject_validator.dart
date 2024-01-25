class SubjectValidator {
	String? courseCode(String? input) {
		if(input!.trim() == '') {
			return 'Course code is required';
		}
		return null;
	}
	String? courseName(String? input) {
		if(input!.trim() == '') {
			return 'Course name is required';
		}
		return null;
	}
	String? semester(String? input) {
		final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
		if(input!.trim() == '') {
			return 'Semester is required';
		}
		else if(!numberCheckRegex.hasMatch(input)) {
			return 'Invalid semester';
		}
		return null;
	}

	String? batch(String? input) {
		return input == null ? 'Select batch' : null;
	}
}