import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
	const CustomTextField({
		super.key, 
		this.onTap,
		this.onChange,
		this.onFieldSubmit,
		this.hintText, 
		this.focusNode,
		this.suffixIcon,
		this.keyboardType, 
		this.obscureText = false, 
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
	final FocusNode? focusNode;
	final void Function()? onTap;
	final TextInputType? keyboardType;
	final void Function(String)? onChange;
	final void Function(String)? onFieldSubmit;
	final String? Function(String?) validator;

	@override
	Widget build(BuildContext context) {
		return TextFormField(
			obscureText: obscureText,
			controller: controller,
			keyboardType: keyboardType,
			validator: validator,
			onChanged: onChange,
			onTap: onTap,
			focusNode: focusNode,
			onFieldSubmitted: onFieldSubmit,
			decoration: InputDecoration(
				contentPadding: const EdgeInsets.all(0),
				prefixIcon: Icon(prefixIcon),
				suffixIcon: suffixIcon,
				prefixIconColor: MaterialStateColor.resolveWith((states) {
					return states.contains(MaterialState.focused) ? const Color(0xFFA95DE7) : Colors.black;
				}),
				labelText: labelText,
				hintText: hintText,
				floatingLabelAlignment: FloatingLabelAlignment.start,
				floatingLabelStyle: const TextStyle(
					color: Color(0xFFA95DE7)
				),
				border: OutlineInputBorder(
					borderSide: const BorderSide(
						color: Colors.black,
					),
					borderRadius: BorderRadius.circular(10)
				),
				enabledBorder: OutlineInputBorder(
					borderSide: const BorderSide(
						color: Colors.black,
					),
					borderRadius: BorderRadius.circular(10)
				),
				focusedBorder: OutlineInputBorder(
					borderSide: const BorderSide(
						color: Color(0xFFA95DE7),
					),
					borderRadius: BorderRadius.circular(10)
				),
			),
		);
	}
}