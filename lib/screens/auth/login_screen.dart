import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ai_lms_project/widgets/custom_textfield.dart';
import 'register_screen.dart';
import '../admin/admin_dashboard.dart';
import '../instructor/instructor_dashboard.dart';
import '../learner/learner_dashboard.dart';

enum Role { Learner, Instructor, Admin }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Role selectedRole = Role.Learner;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final studentIdController = TextEditingController();
  final instructorIdController = TextEditingController();

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackbar("Please fill in all required fields");
      return;
    }

    // Validate Student/Instructor ID based on role
    if (selectedRole == Role.Learner && studentIdController.text.isEmpty) {
      showSnackbar("Please enter your Student ID");
      return;
    }
    if (selectedRole == Role.Instructor && instructorIdController.text.isEmpty) {
      showSnackbar("Please enter your Instructor ID");
      return;
    }

    try {
      final url = Uri.parse('http://localhost:8081/api/verifyToken'); // ✅ Replace with actual IP
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "role": selectedRole.name,
          if (selectedRole == Role.Learner) "studentId": studentIdController.text.trim(),
          if (selectedRole == Role.Instructor) "instructorId": instructorIdController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          showSnackbar("Login successful as ${selectedRole.name}");

          switch (selectedRole) {
            case Role.Learner:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LearnerDashboard()),
              );
              break;
            case Role.Instructor:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InstructorDashboard()),
              );
              break;
            case Role.Admin:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
              break;
          }
        } else {
          showSnackbar(result['message'] ?? 'Login failed');
        }
      } else {
        showSnackbar("Server error: ${response.statusCode}");
      }
    } catch (e) {
      showSnackbar("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxWidth: screenWidth < 500 ? screenWidth : 400,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.deepPurple,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Role selector
                ToggleButtons(
                  isSelected: [
                    selectedRole == Role.Learner,
                    selectedRole == Role.Instructor,
                    selectedRole == Role.Admin,
                  ],
                  onPressed: (index) {
                    setState(() {
                      selectedRole = Role.values[index];
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  selectedColor: Colors.white,
                  fillColor: Colors.deepPurple,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Learner"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Instructor"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Admin"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Email field
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                // Password field
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 12),

                // Student ID field (only for Learners)
                if (selectedRole == Role.Learner)
                  CustomTextField(
                    controller: studentIdController,
                    label: 'Student ID',
                  ),
                if (selectedRole == Role.Learner) const SizedBox(height: 12),

                // Instructor ID field (only for Instructors)
                if (selectedRole == Role.Instructor)
                  CustomTextField(
                    controller: instructorIdController,
                    label: 'Instructor ID',
                  ),
                if (selectedRole == Role.Instructor) const SizedBox(height: 12),

                const SizedBox(height: 12),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: handleLogin,
                  ),
                ),
                const SizedBox(height: 12),

                // Register button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.app_registration, color: Colors.deepPurple),
                    label: const Text(
                      "Register",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepPurple, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
