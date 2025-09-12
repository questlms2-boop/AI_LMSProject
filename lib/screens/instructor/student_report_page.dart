import 'package:flutter/material.dart';
import 'student_details_page.dart';

class StudentReportPage extends StatelessWidget {
  const StudentReportPage({super.key});

  final List<Map<String, dynamic>> studentReports = const [
    {
      'regNo': '2021IT101',
      'name': 'Anjali R',
      'status': 'Completed',
      'points': 120,
    },
    {
      'regNo': '2021IT102',
      'name': 'Kumar V',
      'status': 'In Progress',
      'points': 75,
    },
    {
      'regNo': '2021IT103',
      'name': 'Divya S',
      'status': 'Not Started',
      'points': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Report'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: studentReports.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final student = studentReports[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(student['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Register No: ${student['regNo']}"),
                  Text("Status: ${student['status']}"),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Points',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${student['points']}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailPage(student: student),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
