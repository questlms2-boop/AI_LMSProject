import 'package:flutter/material.dart';
import 'admin_settings_page.dart';
import '../change_password_page.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
        backgroundColor: Color(0xFF6A0DAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/admin_avatar.png',
                ), // Ensure this image exists
              ),
            ),
            const SizedBox(height: 20),
            const Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Kajitha M'),

            const SizedBox(height: 10),
            const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('admin@example.com'),

            const SizedBox(height: 10),
            const Text('Phone:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('+91 9876543210'),

            const SizedBox(height: 10),
            const Text(
              'Designation:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('Admin, AI LMS System'),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminSettingsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text("Go to Settings"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A0DAD),
                ),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.lock),
                label: const Text("Change Password"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A0DAD),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
