import 'package:flutter/material.dart';

class QuizUploadPage extends StatefulWidget {
  const QuizUploadPage({super.key});

  @override
  State<QuizUploadPage> createState() => _QuizUploadPageState();
}

class _QuizUploadPageState extends State<QuizUploadPage> {
  final questionCtrl = TextEditingController();
  final option1Ctrl = TextEditingController();
  final option2Ctrl = TextEditingController();
  final option3Ctrl = TextEditingController();
  final option4Ctrl = TextEditingController();

  List<Map<String, String>> quizList = [];

  void addQuiz() {
    setState(() {
      quizList.add({
        "question": questionCtrl.text,
        "option1": option1Ctrl.text,
        "option2": option2Ctrl.text,
        "option3": option3Ctrl.text,
        "option4": option4Ctrl.text,
      });
      questionCtrl.clear();
      option1Ctrl.clear();
      option2Ctrl.clear();
      option3Ctrl.clear();
      option4Ctrl.clear();
    });
  }

  void deleteQuiz(int index) {
    setState(() {
      quizList.removeAt(index);
    });
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
            TextField(
              controller: questionCtrl,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: option1Ctrl,
              decoration: const InputDecoration(labelText: 'Option 1'),
            ),
            TextField(
              controller: option2Ctrl,
              decoration: const InputDecoration(labelText: 'Option 2'),
            ),
            TextField(
              controller: option3Ctrl,
              decoration: const InputDecoration(labelText: 'Option 3'),
            ),
            TextField(
              controller: option4Ctrl,
              decoration: const InputDecoration(labelText: 'Option 4'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: addQuiz, child: const Text('Add Quiz')),
            const SizedBox(height: 20),
            const Text(
              'Quiz List',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
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
                          Text("1. ${quiz["option1"]}"),
                          Text("2. ${quiz["option2"]}"),
                          Text("3. ${quiz["option3"]}"),
                          Text("4. ${quiz["option4"]}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteQuiz(index),
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
