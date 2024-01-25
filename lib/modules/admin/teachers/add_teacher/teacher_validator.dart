class TeacherValidator {

	String? id(String? input) {
		final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
		if(input!.trim() == '') {
			return 'Id is required';
		}
		else if(!numberCheckRegex.hasMatch(input)) {
			return 'Input only numbers !';
		}
		return null;
	}

	String? name(String? input) {
		if(input!.trim() == '') {
			return 'Name is required';
		}
		return null;
	}

	String? email(String? input) {
		final RegExp emailRegExp = RegExp( r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
		if(input!.trim() == '') {
			return "Email is required";
		}
		else if(!emailRegExp.hasMatch(input.trim())) {
			return 'Invalid email address';
		}
		return null;
	}

	String? phoneNumber(String? input) {
		if(input!.trim() == '') {
			return 'Phone number is required';
		}
		return null;
	}

}