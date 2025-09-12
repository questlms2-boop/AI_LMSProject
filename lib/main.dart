import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/instructor/instructor_dashboard.dart';
import 'screens/change_password_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Role-Based Login',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const LoginScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const InstructorDashboard(),
        '/changePassword': (context) => const ChangePasswordPage(),
      },
    );
  }
} 
