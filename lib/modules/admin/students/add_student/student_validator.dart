class StudentValidator {

	String? name(String? input) {
		if(input!.trim() == '') {
			return 'Name is required';
		}
		return null;
	}

	String? registerNumber(String? input) {
		final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
		if(input!.trim() == '') {
			return 'Register number is required';
		}
		else if(input.trim().length != 4 || !numberCheckRegex.hasMatch(input)) {
			return 'Invalid Register number';
		}
		return null;
	}

	String? rollNumber(String? input) {
		final RegExp numberCheckRegex = RegExp(r'^[0-9]+$');
		if(input!.trim() == '') {
			return 'Roll number is required';
		}
		else if(!numberCheckRegex.hasMatch(input)) {
			return 'Invalid roll number';
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

	String? batch(String? input) {
		if(input!.trim() == '') {
			return 'Batch is required';
		}
		else if(input.trim().length != 7) {
			return 'Invalid batch';
		}
		else {
			RegExp batchRegex = RegExp(r'^\d{4}-(\d{2})$');
			if(!batchRegex.hasMatch(input.trim())) {
				return 'Input on format 2021-24';
			}
			else {
				int startYear = int.tryParse(input.substring(0, 4)) ?? 0;
				int endYear = int.tryParse(input.substring(5, 7)) ?? 0;
				if(startYear - endYear != 1997) {
					return 'Batch years mismatch';
				}
			}
		}
		return null;
	}
}