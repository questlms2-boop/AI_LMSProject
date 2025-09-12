import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  final List<Map<String, String>> users;

  const UserListPage({super.key, required this.users});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  String searchQuery = '';
  String selectedRole = 'All';

  late List<Map<String, String>> filteredUsers;

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users;
  }

  void updateFilter() {
    setState(() {
      filteredUsers = widget.users.where((user) {
        final matchesSearch = user['name']!.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        final matchesRole =
            selectedRole == 'All' ||
            user['role']!.toLowerCase() == selectedRole.toLowerCase();
        return matchesSearch && matchesRole;
      }).toList();
    });
  }

  void deleteUser(int index) {
    setState(() {
      filteredUsers.removeAt(index);
    });
  }

  void editUser(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit user: ${filteredUsers[index]['name']}')),
    );
    // You can navigate to edit form here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E8FF),
      appBar: AppBar(
        title: const Text("All Users"),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    searchQuery = value;
                    updateFilter();
                  },
                  decoration: InputDecoration(
                    hintText: "Search by name...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Filter by role: "),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedRole,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text("All")),
                        DropdownMenuItem(
                          value: 'Learner',
                          child: Text("Learner"),
                        ),
                        DropdownMenuItem(
                          value: 'Instructor',
                          child: Text("Instructor"),
                        ),
                        DropdownMenuItem(value: 'Admin', child: Text("Admin")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          selectedRole = value;
                          updateFilter();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(child: Text("No users found."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF6A0DAD),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(user['name']!),
                          subtitle: Text(user['role']!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () => editUser(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteUser(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
