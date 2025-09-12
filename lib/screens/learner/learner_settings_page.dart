import 'package:flutter/material.dart';
import '../change_password_page.dart'; // Reuse your existing change password page

class LearnerAccountSettingsPage extends StatefulWidget {
  const LearnerAccountSettingsPage({super.key});

  @override
  State<LearnerAccountSettingsPage> createState() =>
      _LearnerAccountSettingsPageState();
}

class _LearnerAccountSettingsPageState
    extends State<LearnerAccountSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  String name = 'Anjali R';
  String email = 'learner@example.com';
  String phone = '+91 9876543210';
  String college = 'ABC Engineering College';

  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController collegeCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: name);
    emailCtrl = TextEditingController(text: email);
    phoneCtrl = TextEditingController(text: phone);
    collegeCtrl = TextEditingController(text: college);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    collegeCtrl.dispose();
    super.dispose();
  }

  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        name = nameCtrl.text;
        email = emailCtrl.text;
        phone = phoneCtrl.text;
        college = collegeCtrl.text;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                saveChanges();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/images/learner_avatar.png',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nameCtrl,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),

              TextFormField(
                controller: emailCtrl,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.contains('@') ? null : 'Enter valid email',
              ),

              TextFormField(
                controller: phoneCtrl,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) =>
                    value!.length >= 10 ? null : 'Enter valid phone number',
              ),

              TextFormField(
                controller: collegeCtrl,
                enabled: _isEditing,
                decoration: const InputDecoration(labelText: 'College Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter your college name' : null,
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.lock),
                label: const Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
