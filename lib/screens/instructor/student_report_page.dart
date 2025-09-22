import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'student_details_page.dart';

class StudentReportPage extends StatefulWidget {
  const StudentReportPage({super.key});

  @override
  _StudentReportPageState createState() => _StudentReportPageState();
}

class _StudentReportPageState extends State<StudentReportPage> {
  late Future<List<Map<String, dynamic>>> _futureStudents;

  @override
  void initState() {
    super.initState();
    _futureStudents = fetchStudents();
  }

  Future<List<Map<String, dynamic>>> fetchStudents() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8081/api/students'));
    
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // Assuming API returns { success: true, data: [...] }
      // Map the JSON data as needed.
      List<dynamic> data = body['data'];
      // Add default or computed 'status' and 'points' as needed, or adjust API to provide them
     return data.map((item) => {
        'username': item['username'] ?? 'N/A',     // for email / mail id in UI
        'name': item['name'] ?? 'Unknown',
        'department': item['department'] ?? 'Unknown',
        'status': 'In Progress',  // or from API if available
        'points': item['xp'],             // or from API if available
      }).toList();

    } else {
      throw Exception('Failed to load students');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Report'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading students: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found'));
          }
          final students = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final student = students[index];
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
                      Text("Department: ${student['department']}"),
                      Text("Mail Id: ${student['username']}"),

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
                        builder: (_) => StudentDetailPage(student: student),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
