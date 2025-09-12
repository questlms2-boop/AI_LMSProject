import 'package:flutter/material.dart';
import 'package:ai_lms_project/screens/auth/login_screen.dart';
import 'learner_settings_page.dart';

class LearnerDashboard extends StatelessWidget {
  const LearnerDashboard({super.key});

  void _navigateToCourseDetail(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseDetailPage(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final imageSize = screenWidth * 0.18;
    final badgeSize = screenWidth * 0.22;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Account Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LearnerAccountSettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Learner Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(80),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        'Your Score',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(width: 6),
                          Text(
                            '1250 XP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.star, color: Colors.amber, size: 32),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                'Earned Badges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: badgeSize + 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _badge('Achiever', badgeSize),
                    _badge('Fast Learner', badgeSize),
                    _badge('Top Scorer', badgeSize),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Course List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _courseTile(
                'Flutter Basics',
                'Beginner',
                'assets/flutter.jpeg',
                imageSize,
              ),
              _courseTile(
                'Java Programming',
                'Intermediate',
                'assets/java.png',
                imageSize,
              ),

              const SizedBox(height: 24),
              const Text(
                'Leaderboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _leaderTile('1. Alice', '1520 XP'),
                    _leaderTile('2. Bob', '1480 XP'),
                    _leaderTile('3. Charlie', '1400 XP'),
                    _leaderTile('4. Diana', '1300 XP'),
                    _leaderTile('5. Evan', '1280 XP'),
                    const Divider(color: Colors.white54),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Your Rank: 12th',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '1250 XP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Learning Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () =>
                    _navigateToCourseDetail(context, 'Flutter Advanced'),
                child: _learningCourse(
                  'Flutter Advanced',
                  '70% Completed',
                  'assets/flutter.jpeg',
                  0.7,
                  imageSize,
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToCourseDetail(context, 'Spring Boot'),
                child: _learningCourse(
                  'Spring Boot',
                  '45% Completed',
                  'assets/java.png',
                  0.45,
                  imageSize,
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Completed Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _navigateToCourseDetail(context, 'HTML & CSS'),
                child: _completedCourse(
                  'HTML & CSS',
                  '100% Completed',
                  'assets/html.jpeg',
                  imageSize,
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToCourseDetail(context, 'Dart Basics'),
                child: _completedCourse(
                  'Dart Basics',
                  '100% Completed',
                  'assets/dart.png',
                  imageSize,
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Mobile Size: ${screenWidth.toInt()} x ${screenHeight.toInt()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, double size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      width: size,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: Colors.deepPurple, size: 40),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _courseTile(
    String title,
    String level,
    String imagePath,
    double imageSize,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(imagePath, width: imageSize, height: imageSize),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(level, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _leaderTile(String name, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                score,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.star, color: Colors.amberAccent, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _completedCourse(
    String title,
    String progress,
    String imagePath,
    double imageSize,
  ) {
    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(imagePath, width: imageSize, height: imageSize),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(progress, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _learningCourse(
    String title,
    String progress,
    String imagePath,
    double percent,
    double imageSize,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(imagePath, width: imageSize, height: imageSize),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        progress,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
              minHeight: 4,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final String title;

  const CourseDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'This is a placeholder description for the course. It explains what the learner will gain.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseContentPage(courseTitle: title),
                    ),
                  );
                },
                child: const Text('Enroll'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseContentPage extends StatelessWidget {
  final String courseTitle;

  const CourseContentPage({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$courseTitle Content'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          'Content for $courseTitle goes here.',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
