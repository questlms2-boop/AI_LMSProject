import 'package:flutter/material.dart';

class PendingCoursesPage extends StatelessWidget {
  const PendingCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Courses'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text("Spring Boot"),
            trailing: Icon(Icons.pending_actions, color: Colors.orange),
          ),
          ListTile(
            title: Text("Dart Basics"),
            trailing: Icon(Icons.pending_actions, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
