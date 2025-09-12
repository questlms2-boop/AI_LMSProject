import 'package:flutter/material.dart';

class StudentDetailPage extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    // Sample sub-data
    final badges = ['Achiever', 'Top Performer'];
    final completedCourses = 4;
    final enrolledOnlyCourses = 2;
    final ongoingCourses = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('${student['name']} - Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoTile("Score", "${student['points']} Points"),
            const SizedBox(height: 12),
            infoTile("Earned Badges", badges.join(', ')),
            const SizedBox(height: 12),
            infoTile("Completed Courses", "$completedCourses"),
            const SizedBox(height: 12),
            infoTile("Enrolled Only Courses", "$enrolledOnlyCourses"),
            const SizedBox(height: 12),
            infoTile("Ongoing Courses", "$ongoingCourses"),
          ],
        ),
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
