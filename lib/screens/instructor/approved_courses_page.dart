import 'package:flutter/material.dart';

class ApprovedCoursesPage extends StatelessWidget {
  const ApprovedCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approved Courses'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text("Flutter Basics"),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
          ListTile(
            title: Text("Java Programming"),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
