import 'package:flutter/material.dart';

class ApprovedCourseCard extends StatelessWidget {
  final String title;
  final String learner;
  final String imageUrl;

  const ApprovedCourseCard({
    super.key,
    required this.title,
    required this.learner,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF3EBFF), // Light violet background
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imageUrl,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Approved for: $learner"),
        trailing: const Icon(Icons.check_circle, color: Colors.green, size: 28),
      ),
    );
  }
}
