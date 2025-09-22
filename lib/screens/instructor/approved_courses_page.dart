import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApprovedCoursesPage extends StatefulWidget {
  const ApprovedCoursesPage({super.key});

  @override
  State<ApprovedCoursesPage> createState() => _ApprovedCoursesPageState();
}

class _ApprovedCoursesPageState extends State<ApprovedCoursesPage> {
  List<Map<String, dynamic>> approvedCourses = [];
  bool isLoading = true;
  final String apiBaseUrl = 'http://127.0.0.1:8081/api';

  @override
  void initState() {
    super.initState();
    fetchApprovedCourses();
  }

  Future<void> fetchApprovedCourses() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/course-content/approved'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          List<dynamic> data = body['data'];
          setState(() {
            approvedCourses = data.cast<Map<String, dynamic>>();
          });
        }
      }
    } catch (e) {
      // Handle error, optionally show message
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approved Courses'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : approvedCourses.isEmpty
              ? const Center(child: Text("No approved courses found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: approvedCourses.length,
                  itemBuilder: (context, index) {
                    final course = approvedCourses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(course['courseName'] ?? 'Unnamed Course'),
                        trailing: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    );
                  },
                ),
    );
  }
}
