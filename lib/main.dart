import 'package:student_analytics/firebase_connect/firebase_options.dart';
import 'package:student_analytics/provider/attendance_provider.dart';
import 'package:student_analytics/provider/students_provider.dart';
import 'package:student_analytics/provider/batch_provider.dart';
import 'package:student_analytics/auth/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:student_analytics/provider/subject_provider.dart';
import 'package:student_analytics/provider/teachers_provider.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform
	);
	runApp(
		MultiProvider(
			providers: [
				ChangeNotifierProvider(create: (context) => SubjectProvider()),
				ChangeNotifierProvider(create: (context) => StudentsProvider()),
				ChangeNotifierProvider(create: (context) => TeachersProvider()),
				ChangeNotifierProvider(create: (context) => AttendanceProvider()),
				ChangeNotifierProvider(create: (context) => StudentsBatchProvider()),
			],
			child: const MyApp(),
		)
	);
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			home: AuthScreen()
		);
	}
}

void sss(Object? ob) {
	// ignore: avoid_print
	print(ob);
}