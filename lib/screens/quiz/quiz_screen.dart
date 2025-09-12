import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  final String role;
  const QuizScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quizzes')),
      body: Center(
        child: Text(
          role == 'learner'
              ? 'Attempt quizzes here'
              : 'Create or manage quizzes',
        ),
      ),
    );
  }
}
