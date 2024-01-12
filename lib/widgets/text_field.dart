import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
	const CustomTextField({
		super.key, 
		this.hintText, 
		this.suffixIcon,
		this.obscureText, 
		this.keyboardType, 
		required this.labelText, 
		required this.prefixIcon, 
		required this.controller, 
		required this.validator, 
	});

	final TextInputType? keyboardType;
	final bool? obscureText;
	final String? hintText;
	final String labelText;
	final IconData prefixIcon;
	final Widget? suffixIcon;
	final TextEditingController controller;
	final String? Function(String?) validator;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			obscureText: obscureText ?? false,
			controller: controller,
			keyboardType: keyboardType,
			validator: validator,
			decoration: InputDecoration(
				contentPadding: const EdgeInsets.all(0),
				prefixIcon: Icon(prefixIcon),
				suffixIcon: suffixIcon,
				prefixIconColor: MaterialStateColor.resolveWith((states) {
					return states.contains(MaterialState.focused) ? Colors.deepPurpleAccent : Colors.black;
				}),
				labelText: labelText,
				hintText: hintText,
				floatingLabelAlignment: FloatingLabelAlignment.start,
				floatingLabelStyle: const TextStyle(
					color: Colors.deepPurpleAccent
				),
				border: OutlineInputBorder(
					borderSide: const BorderSide(
						color: Colors.black,
					),
					borderRadius: BorderRadius.circular(30)
				),
				enabledBorder: OutlineInputBorder(
					borderSide: const BorderSide(
						color: Colors.black,
					),
					borderRadius: BorderRadius.circular(30)
				),
				focusedBorder: OutlineInputBorder(
					borderSide: const BorderSide(
						color: Colors.deepPurpleAccent,
					),
					borderRadius: BorderRadius.circular(30)
				),
			),
		);
	}
}