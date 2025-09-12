import 'package:flutter/material.dart';

class BlockedUserCard extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback onUnblock; 

  const BlockedUserCard({
    super.key,
    required this.name,
    required this.role,
    required this.onUnblock, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.grey[100],
      child: ListTile(
        leading: const Icon(Icons.block, color: Colors.red),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(role),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
          onPressed: () {
            // Optional: Add unblock or delete action
          },
        ),
      ),
    );
  }
}
