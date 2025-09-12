import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  void changePassword() {
    if (_formKey.currentState!.validate()) {
      // Simulate a successful password change (replace this with Firebase logic if needed)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Password Changed"),
          content: const Text("Your password has been updated successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                ); // Go to login
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: oldPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Old Password'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter old password' : null,
              ),
              TextFormField(
                controller: newPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (value) =>
                    value!.length < 6 ? 'Minimum 6 characters required' : null,
              ),
              TextFormField(
                controller: confirmPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                validator: (value) => value != newPasswordCtrl.text
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0DAD),
                ),
                child: const Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
