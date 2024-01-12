import 'package:flutter/material.dart';

class SubjectDashboard extends StatelessWidget {
	SubjectDashboard({super.key});

	final Map<String, dynamic> subject = {
		'name': "Internet of Things",
		'code': '5131'
	};

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(subject['name']),
			),
			body: SafeArea(
				child: Column(
					children: [
						Container(
							width: double.infinity,
							margin: const EdgeInsets.all(10),
							decoration: const BoxDecoration(
								color: Colors.white,
								boxShadow: [
									BoxShadow(
										blurRadius: 2,
										spreadRadius: 0,
										offset: Offset(-2, 2)
									)
								]
							),
							child: ListTile(
								contentPadding: const EdgeInsets.symmetric(horizontal: 10),
								title: Text(
									subject['name'],
									style: const TextStyle(
										fontSize: 17,
										fontWeight: FontWeight.w900
									),
								),
								subtitle: Text(
									subject['code'],
									style: const TextStyle(
										fontSize: 12,
										fontWeight: FontWeight.w600
									),
								),
							),
						),
						const SizedBox(height: 20,),
						Stack(
							alignment: Alignment.center,
							children: [
								SizedBox(
									height: 150,
									width: 150,
									child: CircularProgressIndicator(
										strokeWidth: 8,
										color: Colors.deepPurpleAccent,
										backgroundColor: Colors.grey,
										value: 0.75,
									),
								),
								Column(
									children: [
										Text(
											'${0.75*100}%',
											style: TextStyle(
												fontSize: 25,
												fontWeight: FontWeight.w900
											),
										),
										IconButton(
											onPressed: () {},
											icon: Icon(Icons.expand),
										)
									],
								)
							],
						),
						const SizedBox(height: 40,),
						const ExpansionTile(
							collapsedBackgroundColor: Colors.deepPurpleAccent,
							title: Text('Assignments'),
							children: [
								ListTile(
									title: Text('Assignment 1'),
									subtitle: Text('bla bla bla bla'),
								),
								ListTile(
									title: Text('Assignment 2'),
									subtitle: Text('bla bla bla bla'),
								),
							],
						),
						const SizedBox(height: 2,),
						const ExpansionTile(
							collapsedBackgroundColor: Colors.deepPurpleAccent,
							title: Text('Series Test'),
							children: [
								ListTile(
									title: Text('Series Test 1'),
									subtitle: Text('bla bla bla bla'),
									trailing: CircleAvatar(
										radius: 12,
										child: Text('31'),
									),
								),
								ListTile(
									title: Text('Series Test 1'),
									subtitle: Text('bla bla bla bla'),
									trailing: CircleAvatar(
										radius: 12,
										child: Text('31'),
									),
								),
							],
						),
						
					],
				),
			),
		);
	}
}