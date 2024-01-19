import 'package:flutter/material.dart';

@override
Widget buildTextField(
    BuildContext context,
    String labelText,
    bool obscureText,
    Widget iconButton,
    TextEditingController controller,
    Widget icon,
    String? Function(String?) validator
) {
  	//final height = MediaQuery.of(context).size.height;
  	//final width = MediaQuery.of(context).size.width;
	return Column(
		children: [
		TextFormField(
			validator: validator,
			controller: controller,
			obscureText: obscureText,
			decoration: InputDecoration(
				labelText: labelText,
				border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
				suffixIcon: iconButton,
				prefixIcon: icon,
			)),
		],
	);
}

Widget buildCustomeTextField({
	Widget? prefixIcon,
	Widget? suffixIcon,
	bool obscureText = false,
	required String labelText,
	required TextEditingController controller,
	required String? Function(String?) validator
}) {
	return TextFormField(
		controller: controller,
		validator: validator,
		obscureText: obscureText,
		decoration: InputDecoration(
		labelText: labelText,
		border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
			suffixIcon: suffixIcon,
			prefixIcon: prefixIcon,
		)
	);
}

class CustomTextFieldAthul extends StatelessWidget {
	const CustomTextFieldAthul({
		super.key, 
		this.prefixIcon, 
		this.suffixIcon, 
		this.obscureText = false,
		required this.labelText, 
		required this.controller, 
		required this.validator
	});

	final Widget? prefixIcon;
	final Widget? suffixIcon;
	final bool obscureText;
	final String labelText;
	final TextEditingController controller;
	final String? Function(String?) validator;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			controller: controller,
			validator: validator,
			obscureText: obscureText,
			decoration: InputDecoration(
			labelText: labelText,
			border: OutlineInputBorder(
				borderRadius: BorderRadius.circular(15)),
				suffixIcon: suffixIcon,
				prefixIcon: prefixIcon,
			)
		);
	}
}