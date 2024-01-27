class AssignmentValidator {

	String? title(String? input) {
		return input!.trim() == "" ? 'Please enter title' : null;
	}

	String? description(String? input) {
		return input!.trim() == "" ? 'Please enter description' : null;
	}

	String? dueDate(String? input) {
		RegExp dateRegex = RegExp(r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$');
		if(input!.trim() == '') {
			return 'Please enter due date';
		}
		else if(!dateRegex.hasMatch(input)) {
			return 'Invalid date format';
		}
		else {
			return null;
		}
	}

}