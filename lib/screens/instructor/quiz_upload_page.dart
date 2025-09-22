import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizUploadPage extends StatefulWidget {
  const QuizUploadPage({Key? key}) : super(key: key);

  @override
  State<QuizUploadPage> createState() => _QuizUploadPageState();
}

class _QuizUploadPageState extends State<QuizUploadPage> {
  final questionCtrl = TextEditingController();
  final option1Ctrl = TextEditingController();
  final option2Ctrl = TextEditingController();
  final option3Ctrl = TextEditingController();
  final option4Ctrl = TextEditingController();

  String? selectedCourseId;
  List<dynamic> courseList = [];
  List<dynamic> quizList = [];
  bool loading = false;

  final apiBase = 'http://127.0.0.1:8081';

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final resp = await http.get(Uri.parse('$apiBase/api/course-content'));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body)['data'];
      setState(() {
        courseList = data;
        if (data.isNotEmpty) {
          selectedCourseId = data[0]['_id'];
          fetchQuizzes();
        }
      });
    }
  }

  Future<void> fetchQuizzes() async {
    if (selectedCourseId == null) return;
    setState(() => loading = true);
    final resp = await http.get(Uri.parse('$apiBase/api/quizzes/$selectedCourseId'));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body)['data'];
      setState(() {
        quizList = data;
      });
    }
    setState(() => loading = false);
  }

  Future<void> addQuiz() async {
    if (selectedCourseId == null) return;
    final resp = await http.post(
      Uri.parse('$apiBase/api/quizzes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'courseContentId': selectedCourseId,
        'question': questionCtrl.text,
        'option1': option1Ctrl.text,
        'option2': option2Ctrl.text,
        'option3': option3Ctrl.text,
        'option4': option4Ctrl.text,
        'correctAnswer': option1Ctrl.text, 
      }),
    );
    if (resp.statusCode == 200) {
      questionCtrl.clear();
      option1Ctrl.clear();
      option2Ctrl.clear();
      option3Ctrl.clear();
      option4Ctrl.clear();
      fetchQuizzes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Quiz Content'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedCourseId,
              items: courseList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['_id'],
                  child: Text(item['courseName']),
                );
              }).toList(),
              hint: const Text('Select Course'),
              onChanged: (val) {
                setState(() {
                  selectedCourseId = val;
                  fetchQuizzes();
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(controller: questionCtrl, decoration: const InputDecoration(labelText: 'Question')),
            TextField(controller: option1Ctrl, decoration: const InputDecoration(labelText: 'Option 1')),
            TextField(controller: option2Ctrl, decoration: const InputDecoration(labelText: 'Option 2')),
            TextField(controller: option3Ctrl, decoration: const InputDecoration(labelText: 'Option 3')),
            TextField(controller: option4Ctrl, decoration: const InputDecoration(labelText: 'Option 4')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: addQuiz,
              child: const Text('Add Quiz'),
            ),
            const SizedBox(height: 20),
            const Text('Quiz List', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: quizList.length,
                      itemBuilder: (context, index) {
                        final quiz = quizList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(quiz["question"] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("1. ${quiz["option1"] ?? ""}"),
                                Text("2. ${quiz["option2"] ?? ""}"),
                                Text("3. ${quiz["option3"] ?? ""}"),
                                Text("4. ${quiz["option4"] ?? ""}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
