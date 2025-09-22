import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Course {
  final String id;
  final String courseName;

  Course({required this.id, required this.courseName});

  factory Course.fromJson(Map<String, dynamic> json) =>
      Course(id: json['_id'], courseName: json['courseName']);
}

class QuizPage extends StatefulWidget {
  final Course course;
  final String userId;

  QuizPage({required this.course, required this.userId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class QuizItem {
  final String id;
  final String question;
  final List<String> options;

  QuizItem({required this.id, required this.question, required this.options});

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      id: json['_id'],
      question: json['question'],
      options: [
        json['option1'] ?? '',
        json['option2'] ?? '',
        json['option3'] ?? '',
        json['option4'] ?? '',
      ],
    );
  }
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<QuizItem>> _quizzesFuture;
  Map<String, String> _selectedAnswers = {};
  bool _submitted = false;
  int _earnedPoints = 0;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = fetchQuizzes();
  }

  Future<List<QuizItem>> fetchQuizzes() async {
    final resp = await http.get(Uri.parse('http://127.0.0.1:8081/api/quizzes/${widget.course.id}'));
    final body = jsonDecode(resp.body);
    List data = body['data'];
    return data.map((json) => QuizItem.fromJson(json)).toList();
  }

  Future<void> _submitQuiz() async {
    var answers = _selectedAnswers.entries
        .map((e) => {'quizId': e.key, 'selectedOption': e.value})
        .toList();

    final resp = await http.post(
      Uri.parse('http://127.0.0.1:8081/api/user-quizzes/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': widget.userId,
        'courseContentId': widget.course.id,
        'answers': answers,
      }),
    );

    final body = jsonDecode(resp.body);
    if (body['success']) {
      setState(() {
        _earnedPoints = body['totalScore'];
        _submitted = true;
      });
      // Return true to signal dashboard to refresh progress
      Navigator.of(context).pop(true);
    } else {
      // Handle submission error (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message'] ?? 'Failed to submit quiz')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.course.courseName} Result')),
        body: Center(
          child: Text('You earned $_earnedPoints XP!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.courseName)),
      body: FutureBuilder<List<QuizItem>>(
        future: _quizzesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var quizzes = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              ...quizzes.map((quiz) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quiz.question, style: TextStyle(fontWeight: FontWeight.bold)),
                    ...quiz.options.map((opt) {
                      return RadioListTile<String>(
                        groupValue: _selectedAnswers[quiz.id],
                        value: opt,
                        title: Text(opt),
                        onChanged: (val) {
                          setState(() {
                            _selectedAnswers[quiz.id] = val!;
                          });
                        },
                      );
                    }).toList(),
                    Divider(),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed:
                    _selectedAnswers.length == quizzes.length ? _submitQuiz : null,
                child: Text('Submit Quiz'),
              ),
            ],
          );
        },
      ),
    );
  }
}
