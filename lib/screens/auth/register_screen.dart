import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ai_lms_project/widgets/custom_textfield.dart';
import 'package:ai_lms_project/screens/auth/login_screen.dart';
import 'package:ai_lms_project/screens/instructor/instructor_dashboard.dart';
import 'package:ai_lms_project/screens/learner/learner_dashboard.dart';

enum Role { Student, Instructor }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Role selectedRole = Role.Student;

  // Common fields
  final idCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  // Student-specific
  String? selectedDepartment;
  String? selectedClass;

  // Instructor-specific
  String? selectedInstructorDepartment;

  final List<String> departments = ["CSE", "IT", "ECE", "EEE", "MECH", "CIVIL"];
  final List<String> classes = ["I Year", "II Year", "III Year", "IV Year"];

  void showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
Future<void> registerUser() async {
  if (idCtrl.text.isEmpty ||
      nameCtrl.text.isEmpty ||
      emailCtrl.text.isEmpty ||
      passwordCtrl.text.isEmpty ||
      confirmPasswordCtrl.text.isEmpty) {
    showSnack("Please fill in all required fields");
    return;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  if (!isValidEmail(emailCtrl.text.trim())) {
    showSnack("Please enter a valid email address");
    return;
  }

  if (passwordCtrl.text != confirmPasswordCtrl.text) {
    showSnack("Passwords do not match");
    return;
  }

  if (selectedRole == Role.Student) {
    if (selectedDepartment == null || selectedClass == null) {
      showSnack("Please select department and class");
      return;
    }
  } else if (selectedRole == Role.Instructor) {
    if (selectedInstructorDepartment == null) {
      showSnack("Please select department");
      return;
    }
  }

  try {
    final url = Uri.parse('http://10.0.2.2:8081/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': idCtrl.text,
        'name': nameCtrl.text,
        'email': emailCtrl.text.trim(),
        'role': selectedRole.name,
        'department': selectedRole == Role.Student
            ? selectedDepartment
            : selectedInstructorDepartment,
        'class': selectedRole == Role.Student ? selectedClass : null,
        'password': passwordCtrl.text,
      }),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 && result['success'] == true) {
      // Navigate based on role
      if (selectedRole == Role.Student) {
        Navigator.pushReplacement(
          context,
         MaterialPageRoute(builder: (_) => LearnerDashboard(userId: result['userId'])),

        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InstructorDashboard()),
        );
      }
    } else {
      showSnack(result['message'] ?? "Registration failed");
    }
  } catch (e) {
    showSnack("Error: $e");
  }
}


  Widget getRoleForm() {
    if (selectedRole == Role.Student) {
      return Column(
        children: [
          CustomTextField(controller: idCtrl, label: 'Student ID'),
          CustomTextField(controller: nameCtrl, label: 'Name'),
          CustomTextField(controller: emailCtrl, label: 'Email'),
          DropdownButtonFormField<String>(
            value: selectedDepartment,
            decoration: const InputDecoration(labelText: "Select Department"),
            items: departments
                .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                .toList(),
            onChanged: (value) => setState(() => selectedDepartment = value),
          ),
          DropdownButtonFormField<String>(
            value: selectedClass,
            decoration: const InputDecoration(labelText: "Select Class"),
            items: classes
                .map((cls) => DropdownMenuItem(value: cls, child: Text(cls)))
                .toList(),
            onChanged: (value) => setState(() => selectedClass = value),
          ),
          CustomTextField(
            controller: passwordCtrl,
            label: 'Password',
            obscureText: true,
          ),
          CustomTextField(
            controller: confirmPasswordCtrl,
            label: 'Confirm Password',
            obscureText: true,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          CustomTextField(controller: idCtrl, label: 'Instructor ID'),
          CustomTextField(controller: nameCtrl, label: 'Name'),
          CustomTextField(controller: emailCtrl, label: 'Email'),
          DropdownButtonFormField<String>(
            value: selectedInstructorDepartment,
            decoration: const InputDecoration(labelText: "Select Department"),
            items: departments
                .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                .toList(),
            onChanged: (value) =>
                setState(() => selectedInstructorDepartment = value),
          ),
          CustomTextField(
            controller: passwordCtrl,
            label: 'Password',
            obscureText: true,
          ),
          CustomTextField(
            controller: confirmPasswordCtrl,
            label: 'Confirm Password',
            obscureText: true,
          ),
        ],
      );
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
                Text(
                  'Register as ${selectedRole.name}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ToggleButtons(
                  isSelected: [
                    selectedRole == Role.Student,
                    selectedRole == Role.Instructor,
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
                      child: Text("Student"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Instructor"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                getRoleForm(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text("Register"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: registerUser,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
