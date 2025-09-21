import 'package:ai_lms_project/screens/widgets/blocked_user_card.dart';
import 'package:flutter/material.dart';
import 'package:ai_lms_project/widgets/user_card.dart';
import 'course_approval_card.dart';
import 'approved_course_card.dart';
import 'package:ai_lms_project/screens/admin/user_list_page.dart';
import 'admin_profile_page.dart';
import 'admin_settings_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> blockedUsers = [];
  List<Map<String, dynamic>> pastMembers = [];
 List<Map<String, dynamic>> courses = [];
  bool loadingUsers = false;
bool loadingCourses = false;
  final String apiBaseUrl = 'http://10.0.2.2:8081/api'; // Adjust as needed

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchCourses();

  }

  Future<void> fetchUsers() async {
    setState(() => loadingUsers = true);
    try {
      final resp = await http.get(Uri.parse('$apiBaseUrl/users'));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == true) {
          final List<dynamic> fetchedUsers = data['data'];
          setState(() {
            users = fetchedUsers.cast<Map<String, dynamic>>();
          });
        }
      }
    } catch (e) {
      // Handle error
    }
    setState(() => loadingUsers = false);
  }

  Future<void> fetchCourses() async {
  setState(() => loadingCourses = true);
  try {
    final resp = await http.get(Uri.parse('$apiBaseUrl/course-content'));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['success'] == true) {
        final List<dynamic> fetchedCourses = data['data'];
        setState(() {
          courses = fetchedCourses.cast<Map<String, dynamic>>();
        });
      }
    }
  } catch (e) {
    // Error handling here
  }
  setState(() => loadingCourses = false);
}

Future<void> approveCourse(String courseId) async {
  final url = Uri.parse('http://10.0.2.2:8081/api/course-content/$courseId/approve');
  final response = await http.patch(url);

  if (response.statusCode == 200) {
    // Optionally refresh course list or update UI
  } else {
    // Handle error
  }
}

Future<List<dynamic>> fetchQuizzes(String courseId) async {
  try {
    final response = await http.get(Uri.parse('$apiBaseUrl/quizzes/$courseId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'];
      }
    }
  } catch (e) {
    // Handle error
  }
  return [];
}

Future<void> showQuizzes(BuildContext context, String courseId, String courseName) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FutureBuilder<List<dynamic>>(
        future: fetchQuizzes(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 200,
              child: Center(child: Text('Failed to load quizzes')),
            );
          } else {
            final quizzes = snapshot.data ?? [];
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quizzes for "$courseName"',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: quizzes.isEmpty
                        ? const Center(child: Text("No quizzes available"))
                        : ListView.builder(
                            itemCount: quizzes.length,
                            itemBuilder: (context, index) {
                              final quiz = quizzes[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(quiz['question'] ?? ''),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("1. ${quiz['option1'] ?? ''}"),
                                      Text("2. ${quiz['option2'] ?? ''}"),
                                      Text("3. ${quiz['option3'] ?? ''}"),
                                      Text("4. ${quiz['option4'] ?? ''}"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            );
          }
        },
      );
    },
  );
}


  Future<void> deleteUser(String userId) async {
    try {
      final resp = await http.delete(Uri.parse('$apiBaseUrl/users/$userId'));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == true) {
          showSnackBar('User deleted');
          fetchUsers(); // Refresh list
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  void blockUser(Map<String, dynamic> user) {
    setState(() {
      users.removeWhere((u) => u['_id'] == user['_id']);
      blockedUsers.add(user);
    });
  }

  void removeUser(Map<String, dynamic> user) {
    setState(() {
      users.removeWhere((u) => u['_id'] == user['_id']);
      pastMembers.add(user);
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF2E8FF),
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'settings', child: Text('Account Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),

    body: loadingUsers
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: "User Management"),
                ...users.take(2).map(
                      (user) => UserCard(
                        userName: user['name'],
                        userRole: user['role'],
                        onDelete: () => deleteUser(user['_id']),
                        // onBlock: () => blockUser(user),
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
                const SectionHeader(title: "Courses Uploaded by Instructors"),
                loadingCourses
                    ? const Center(child: CircularProgressIndicator())
                    :Column(
                  children: courses.map<Widget>((course) {
                    bool isApproved = course['approved'] == true;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(course['courseName'] ?? 'Unnamed Course'),
                        subtitle: Text(
                          'Created on: ${DateTime.parse(course['createdAt']).toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: isApproved
                            ? Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Approved',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  approveCourse(course['_id']);
                                },
                                child: const Text('Approve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                        onTap: () => showQuizzes(context, course['_id'], course['courseName'] ?? ''),
                      ),
                    );
                  }).toList(),
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
