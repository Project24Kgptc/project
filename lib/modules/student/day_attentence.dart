import 'package:flutter/material.dart';
import 'package:student_analytics/data_models/attendance_model.dart';

class DayAttentence extends StatelessWidget {
  const DayAttentence(
      {super.key, required this.subject, required this.attentenceList});
  final List<AttendanceModel> attentenceList;
  final String subject;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text('Date'),Text('Hour'),Text('Added By'),]),
          Expanded(
            child: ListView.builder(
              itemCount: attentenceList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(attentenceList[index].date),
                    Text(attentenceList[index].hour),
                    Text(attentenceList[index].teacherName)
                  ],
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
