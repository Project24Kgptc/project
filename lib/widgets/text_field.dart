import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
	const CustomTextField({
		super.key, 
		this.hintText, 
		this.suffixIcon,
		this.obscureText = false, 
		this.keyboardType, 
		this.onChange,
		required this.labelText, 
		required this.prefixIcon, 
		required this.controller, 
		required this.validator, 
	});

	final bool obscureText;
	final String labelText;
	final IconData prefixIcon;
	final TextEditingController controller;
	final String? hintText;
	final Widget? suffixIcon;
	final TextInputType? keyboardType;
	final String? Function(String?) validator;
	final void Function(String)? onChange;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			obscureText: obscureText,
			controller: controller,
			keyboardType: keyboardType,
			validator: validator,
			onChanged: onChange,
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