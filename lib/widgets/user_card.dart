import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String userRole;

  const UserCard({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF6A0DAD),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          userRole,
          style: const TextStyle(color: Colors.deepPurple),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {},
          child: Text("Block"),
        ),
      ),
    );
  }
}


