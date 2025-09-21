import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PendingCoursesPage extends StatefulWidget {
  const PendingCoursesPage({super.key});

  @override
  State<PendingCoursesPage> createState() => _PendingCoursesPageState();
}

class _PendingCoursesPageState extends State<PendingCoursesPage> {
  List<Map<String, dynamic>> pendingCourses = [];
  bool isLoading = true;
  final String apiBaseUrl = 'http://10.0.2.2:8081/api';

  @override
  void initState() {
    super.initState();
    fetchPendingCourses();
  }

  Future<void> fetchPendingCourses() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/course-content/pending'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          List<dynamic> data = body['data'];
          setState(() {
            pendingCourses = data.cast<Map<String, dynamic>>();
          });
        }
      }
    } catch (e) {
      // Optionally handle error
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Courses'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingCourses.isEmpty
              ? const Center(child: Text("No pending courses found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingCourses.length,
                  itemBuilder: (context, index) {
                    final course = pendingCourses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(course['courseName'] ?? 'Unnamed Course'),
                        trailing: const Icon(Icons.pending_actions, color: Colors.orange),
                      ),
                    );
                  },
                ),
    );
  }
}
