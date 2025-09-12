import 'package:flutter/material.dart';

class InstructorProfilePage extends StatelessWidget {
  const InstructorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructor Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Name'),
              subtitle: Text('Anjali R'),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('College Name'),
              subtitle: Text('ABC College of Engineering'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('anjali@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
              subtitle: Text('+91 9876543210'),
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Department'),
              subtitle: Text('Information Technology'),
            ),
          ],
        ),
      ),
    );
  }
}
