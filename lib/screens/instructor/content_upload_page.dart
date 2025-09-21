import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContentUploadPage extends StatefulWidget {
  const ContentUploadPage({Key? key}) : super(key: key);

  @override
  State<ContentUploadPage> createState() => _ContentUploadPageState();
}

class _ContentUploadPageState extends State<ContentUploadPage> {
  final TextEditingController courseNameCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();
  List<dynamic> contentList = [];
  bool loading = false;

  final String apiUrl = 'http://10.0.2.2:8081/api/course-content';

  @override
  void initState() {
    super.initState();
    fetchContents();
  }

  Future<void> fetchContents() async {
    setState(() => loading = true);
    try {
      final resp = await http.get(Uri.parse(apiUrl));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          contentList = data['data'];
        });
      }
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> createContent() async {
    final courseName = courseNameCtrl.text;
    final content = contentCtrl.text;
    if (courseName.isEmpty || content.isEmpty) return;

    setState(() => loading = true);
    final resp = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'courseName': courseName, 'content': content}),
    );
    if (resp.statusCode == 200) {
      courseNameCtrl.clear();
      contentCtrl.clear();
      await fetchContents();
    } else {
      // Error handling, e.g., show snackbar
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Course Content'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  ElevatedButton(
                    onPressed: loading ? null : createContent,
                    child: const Text('Create'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              loading
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: contentList.length,
                      itemBuilder: (context, idx) {
                        final item = contentList[idx];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(item['courseName'] ?? ''),
                            subtitle: Text(item['content'] ?? ''),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
