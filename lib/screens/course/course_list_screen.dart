import 'package:flutter/material.dart';

class CourseListScreen extends StatelessWidget {
  final String role;
  CourseListScreen({super.key, required this.role});

  final dummyCourses = [
    {'title': 'Flutter Basics'},
    {'title': 'Spring Boot Intro'},
    {'title': 'AI in Education'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Courses')),
      body: ListView.builder(
        itemCount: dummyCourses.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(dummyCourses[i]['title']!),
          trailing: role == 'instructor' ? Icon(Icons.edit) : null,
        ),
      ),
    );
  }
}
