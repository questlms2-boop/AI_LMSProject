import 'package:ai_lms_project/screens/widgets/blocked_user_card.dart';
import 'package:flutter/material.dart';
import 'package:ai_lms_project/widgets/user_card.dart';
import 'course_approval_card.dart';
import 'approved_course_card.dart';
import 'package:ai_lms_project/screens/admin/user_list_page.dart';
import 'admin_profile_page.dart';
import 'admin_settings_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, String>> users = [
    {'name': 'John Doe', 'role': 'Learner'},
    {'name': 'Jane Doe', 'role': 'Learner'},
    {'name': 'Alice Smith', 'role': 'Learner'},
    {'name': 'Bob Johnson', 'role': 'Learner'},
    {'name': 'Alice Johnson', 'role': 'Learner'},
    {'name': 'Bob Brown', 'role': 'Learner'},
    {'name': 'Charlie Davis', 'role': 'Instructor'},
    {'name': 'David Wilson', 'role': 'Instructor'},
    {'name': 'Eve White', 'role': 'Instructor'},
    {'name': 'Frank Black', 'role': 'Instructor'},
    {'name': 'Grace Green', 'role': 'Instructor'},
    {'name': 'Hank Blue', 'role': 'Instructor'},
    {'name': 'Jane Smith', 'role': 'Instructor'},
  ];

  List<Map<String, String>> blockedUsers = [
    {'name': 'Zack Lee', 'role': 'Learner'},
    {'name': 'Nina Patel', 'role': 'Instructor'},
    {'name': 'Ravi Kumar', 'role': 'Learner'},
  ];

  List<Map<String, String>> pastMembers = [];

  final List<Map<String, String>> pendingCourses = [
    {
      'title': 'Flutter Basics',
      'instructor': 'Alice',
      'image': 'assets/flutter.jpeg',
    },
    {'title': 'Java Mastery', 'instructor': 'Bob', 'image': 'assets/java.png'},
    {
      'title': 'Data Science with R',
      'instructor': 'Charlie',
      'image': 'assets/r.jpeg',
    },
    {
      'title': 'Machine Learning with Python',
      'instructor': 'David',
      'image': 'assets/ml.jpeg',
    },
    {
      'title': 'Web Development with React',
      'instructor': 'Eve',
      'image': 'assets/react.png',
    },
    {
      'title': 'AI and Deep Learning',
      'instructor': 'Frank',
      'image': 'assets/ai.jpeg',
    },
    {
      'title': 'Blockchain Technology',
      'instructor': 'Grace',
      'image': 'assets/blockchain.jpeg',
    },
    {
      'title': 'Cybersecurity Essentials',
      'instructor': 'Hank',
      'image': 'assets/cybersecurity.jpeg',
    },
    {
      'title': 'Cloud Computing with AWS',
      'instructor': 'Ivy',
      'image': 'assets/aws.jpeg',
    },
    {
      'title': 'Mobile App Development',
      'instructor': 'Jack',
      'image': 'assets/mobile.jpeg',
    },
  ];

  final List<Map<String, String>> approvedCourses = [
    {'title': 'React Guide', 'learner': 'Charlie', 'image': 'assets/react.png'},
    {
      'title': 'Python for Data Science',
      'learner': 'David',
      'image': 'assets/python.png',
    },
    {'title': 'AI Fundamentals', 'learner': 'Eve', 'image': 'assets/ai.jpeg'},
    {
      'title': 'Web Development with Django',
      'learner': 'Frank',
      'image': 'assets/django.jpeg',
    },
    {
      'title': 'Introduction to SQL',
      'learner': 'Grace',
      'image': 'assets/sql.png',
    },
    {
      'title': 'DevOps Practices',
      'learner': 'Hank',
      'image': 'assets/devops.jpeg',
    },
    {
      'title': 'Introduction to Kubernetes',
      'learner': 'Ivy',
      'image': 'assets/kubernetes.png',
    },
    {
      'title': 'Introduction to Docker',
      'learner': 'Jack',
      'image': 'assets/docker.png',
    },
    {
      'title': 'Introduction to Git',
      'learner': 'Alice',
      'image': 'assets/git.jpeg',
    },
  ];

  void approveCourse(Map<String, String> course) {
    setState(() {
      pendingCourses.remove(course);
      approvedCourses.add({
        'title': course['title']!,
        'learner': course['instructor']!,
        'image': course['image']!,
      });
    });
  }

  void blockUser(Map<String, String> user) {
    setState(() {
      users.remove(user);
      blockedUsers.add(user);
    });
  }

  void removeUser(Map<String, String> user) {
    setState(() {
      users.remove(user);
      pastMembers.add(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E8FF),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: const Color(0xFF6A0DAD),
        elevation: 4,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminProfilePage()),
                );
              } else if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminSettingsPage()),
                );
              } else if (value == 'logout') {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Account Settings'),
              ),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: "User Management"),
            ...users
                .take(2)
                .map(
                  (user) => UserCard(
                    userName: user['name']!,
                    userRole: user['role']!,
                  ),
                ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserListPage(users: users),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: Color(0xFF6A0DAD)),
                label: const Text(
                  "View All",
                  style: TextStyle(
                    color: Color(0xFF6A0DAD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: "Courses Awaiting Approval"),
            ...pendingCourses.map(
              (course) => CourseApprovalCard(
                title: course['title']!,
                instructor: course['instructor']!,
                imageUrl: course['image']!,
              ),
            ),
            const Divider(height: 32, thickness: 2, color: Color(0xFFBDA8DC)),
            const SectionHeader(title: "Approved Courses"),
            ...approvedCourses.map(
              (course) => ApprovedCourseCard(
                title: course['title']!,
                learner: course['learner']!,
                imageUrl: course['image']!,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 32, thickness: 1),
            const SectionHeader(title: "Blocked Users"),
            if (blockedUsers.isEmpty)
              const Text(
                "No blocked users",
                style: TextStyle(color: Colors.black54),
              ),
            ...blockedUsers.map(
              (user) => BlockedUserCard(
                name: user['name']!,
                role: user['role']!,
                onUnblock: () {
                  setState(() {
                    blockedUsers.remove(user);
                    users.add(user); // Move back to users list
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6A0DAD),
        ),
      ),
    );
  }
}
