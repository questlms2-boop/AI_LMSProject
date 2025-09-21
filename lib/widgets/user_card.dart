import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String userRole;
  final VoidCallback? onBlock;
  final VoidCallback? onDelete;

  const UserCard({
    super.key,
    required this.userName,
    required this.userRole,
    this.onBlock,
    this.onDelete,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onBlock != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: onBlock,
                child: const Text("Block"),
              ),
            const SizedBox(width: 8),
            if (onDelete != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: onDelete,
                child: const Text("Delete"),
              ),
          ],
        ),
      ),
    );
  }
}
