import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final dummyLeaders = [
    {'name': 'Alice', 'points': 150},
    {'name': 'Bob', 'points': 120},
    {'name': 'Charlie', 'points': 100},
  ];

  LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: ListView.builder(
        itemCount: dummyLeaders.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: CircleAvatar(child: Text('${i + 1}')),
          title: Text(dummyLeaders[i]['name']!.toString()),
          trailing: Text('${dummyLeaders[i]['points']} XP'),
        ),
      ),
    );
  }
}
