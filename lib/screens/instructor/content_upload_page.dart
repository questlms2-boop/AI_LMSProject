import 'package:flutter/material.dart';

class ContentUploadPage extends StatelessWidget {
  const ContentUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseNameCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Course Content'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: courseNameCtrl,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Create')),
                ElevatedButton(onPressed: () {}, child: const Text('Edit')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
