import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ai_lms_project/screens/quiz/quiz_screen.dart';

class UserCourseProgress {
  final String courseId;
  final String courseName;
  final int totalQuizzes;
  final int attemptedCount;
  final int correctCount;
  final bool completed;

  UserCourseProgress({
    required this.courseId,
    required this.courseName,
    required this.totalQuizzes,
    required this.attemptedCount,
    required this.correctCount,
    required this.completed,
  });

  factory UserCourseProgress.fromJson(Map<String, dynamic> json) => UserCourseProgress(
    courseId: json['courseId'],
    courseName: json['courseName'],
    totalQuizzes: json['totalQuizzes'],
    attemptedCount: json['attemptedCount'],
    correctCount: json['correctCount'],
    completed: json['completed'],
  );
}


class LearnerDashboard extends StatefulWidget {
  final String userId;
  const LearnerDashboard({required this.userId, super.key});

  @override
  State<LearnerDashboard> createState() => _LearnerDashboardState();
}

class _LearnerDashboardState extends State<LearnerDashboard> {
  late Future<List<Course>> _coursesFuture;
  late Future<List<UserCourseProgress>> _progressFuture;
  late Future<List<LeaderboardEntry>> _leaderboardFuture;

  int _topScore = 0;

  @override
  void initState() {
    super.initState();
    _coursesFuture = fetchCourses();
    _progressFuture = fetchUserProgress(widget.userId);
    _leaderboardFuture = fetchLeaderboard();
  }

  Future<List<Course>> fetchCourses() async {
    final resp = await http.get(Uri.parse('http://10.0.2.2:8081/api/course-content'));
    final body = jsonDecode(resp.body);
    List data = body['data'];
    return data.map((c) => Course.fromJson(c)).toList();
  }

  Future<List<UserCourseProgress>> fetchUserProgress(String userId) async {
    final resp = await http.get(Uri.parse('http://10.0.2.2:8081/api/user-progress/$userId'));
    final body = jsonDecode(resp.body);
    print("user-progress response: ${resp.body}");
    List data = body['data'];
    // Also update top score locally (simulate here)
    // Sum total XP from all courses
    int totalXp = 0;
    for (var course in data) {
      var xpValue = course['xp'];
      if (xpValue is num && xpValue > totalXp) {
        totalXp = xpValue.toInt();
      }
    }
    setState(() {
      _topScore = totalXp;
    });

    
    return data.map((json) => UserCourseProgress.fromJson(json)).toList();
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final resp = await http.get(Uri.parse('http://10.0.2.2:8081/api/leaderboard'));
    final body = jsonDecode(resp.body);
    List data = body['data'];
    return data.map((json) => LeaderboardEntry.fromJson(json)).toList();
  }

 void _navigateToQuiz(BuildContext context, Course course) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => QuizPage(course: course, userId: widget.userId),
    ),
  );
  if (result == true) {
    // Refresh progress and leaderboard after quiz submission
    setState(() {
      _progressFuture = fetchUserProgress(widget.userId);
      _leaderboardFuture = fetchLeaderboard();
    });
  }
}


  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
    title: const Text('Learner Dashboard'),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
  ),
  body: RefreshIndicator(
    onRefresh: () async {
      setState(() {
        _coursesFuture = fetchCourses();
        _progressFuture = fetchUserProgress(widget.userId);
        _leaderboardFuture = fetchLeaderboard();
      });
    },
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopScoreCard(),
            const SizedBox(height: 16),
            _buildSectionTitle('Leaderboard'),
            _buildLeaderboardSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Courses'),
            _buildCoursesSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('Your Progress'),
            _buildProgressSection(),
          ],
        ),
      ),
    ),
  ),
);

  }

  Widget _buildTopScoreCard() {
    return Card(
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 36),
            const SizedBox(width: 12),
            Text(
              'Your Score: $_topScore XP',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepPurple),
    );
  }

  Widget _buildLeaderboardSection() {
    return FutureBuilder<List<LeaderboardEntry>>(
      future: _leaderboardFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final leaders = snapshot.data!;
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: leaders.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final leader = leaders[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(leader.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${leader.xp} XP', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, color: Colors.amber),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCoursesSection() {
    return FutureBuilder<List<Course>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final courses = snapshot.data!;
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: courses.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                title: Text(course.courseName),
                trailing: ElevatedButton(
                  onPressed: () => _navigateToQuiz(context, course),
                  child: const Text('Start Quiz'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return FutureBuilder<List<UserCourseProgress>>(
      future: _progressFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final progresses = snapshot.data!;
        final completed = progresses.where((p) => p.completed).toList();
        final ongoing = progresses.where((p) => !p.completed).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Completed Courses (${completed.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
            completed.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No completed courses yet.'),
                  )
                : _buildCourseStatusList(completed),
            const SizedBox(height: 12),
            Text('Ongoing Courses (${ongoing.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
            ongoing.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No ongoing courses currently.'),
                  )
                : _buildCourseStatusList(ongoing),
          ],
        );
      },
    );
  }

Widget _buildCourseStatusList(List<UserCourseProgress> courses) {
  if (courses.isEmpty) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text("No courses in this section.", style: TextStyle(color: Colors.grey[600])),
    );
  }
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: courses.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final progress = courses[index];
        final completionPercent = progress.totalQuizzes == 0
            ? 0.0
            : (progress.attemptedCount / progress.totalQuizzes).clamp(0.0, 1.0);
        return ListTile(
          title: Text(progress.courseName),
          subtitle: LinearProgressIndicator(
            value: completionPercent,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            color: Colors.deepPurple,
          ),
          trailing: Text('${(completionPercent * 100).toStringAsFixed(0)}%'),
        );
      },
    ),
  );
}

}

class LeaderboardEntry {
  final String name;
  final int xp;
  LeaderboardEntry({required this.name, required this.xp});
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      name: json['name'] ?? 'Unknown',
      xp: json['xp'] ?? 0,
    );
  }
}
