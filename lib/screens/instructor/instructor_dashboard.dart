import 'package:flutter/material.dart';
import 'student_report_page.dart';
import 'approved_courses_page.dart';
import 'pending_courses_page.dart';
import 'content_upload_page.dart';
import 'quiz_upload_page.dart';
import 'instructor_profile_page.dart';

class InstructorDashboard extends StatelessWidget {
  const InstructorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Instructor Dashboard'),
  backgroundColor: Colors.deepPurple,
  actions: [
    PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InstructorProfilePage()),
          );
        } else if (value == 'logout') {
          // Navigate to Login Page or Welcome Screen
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('Account Details'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
      icon: const Icon(Icons.account_circle),
    ),
  ],
),

      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _dashboardCard(
            context,
            icon: Icons.people,
            title: 'Student Report',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentReportPage()),
              );
            },
          ),
          _dashboardCard(
            context,
            icon: Icons.check_circle,
            title: 'Approved Courses',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ApprovedCoursesPage()),
              );
            },
          ),
          _dashboardCard(
            context,
            icon: Icons.pending_actions,
            title: 'Pending Courses',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PendingCoursesPage()),
              );
            },
          ),
          _dashboardCard(
            context,
            icon: Icons.upload_file,
            title: 'Content Uploading',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContentUploadPage()),
              );
            },
          ),
          _dashboardCard(
            context,
            icon: Icons.quiz,
            title: 'Quiz Uploading',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizUploadPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.deepPurple.shade100,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
