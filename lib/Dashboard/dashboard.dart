import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final purple = const Color(0xFF6C4DFE);
  late Future<List<Map<String, dynamic>>> projects;
  late Future<List<Map<String, dynamic>>> tasks;

  @override
  void initState() {
    super.initState();
    projects = fetchProjects();
    tasks = fetchTasks();
  }

  Future<List<Map<String, dynamic>>> fetchProjects() async {
    final snapshot = await FirebaseFirestore.instance.collection('projects').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              buildHeader(),
              const SizedBox(height: 20),
              buildSearchBar(),
              const SizedBox(height: 20),
              buildTabs(),
              const SizedBox(height: 20),
              buildProjectSection(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(

                  children: [
                    Icon(Icons.app_registration_rounded,color: Colors.amber,),
                    Text(
                      "Your recent tasks",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 90,),
                    Icon(Icons.arrow_circle_down,color: Colors.grey,),

                  ],
                ),
              ),
              buildTaskSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  Widget buildProjectSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: projects,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final data = snapshot.data!;
        if (data.isEmpty) return const Text("No projects found.");

        final project = data.first;
        final double progress = double.tryParse(project['progress'] ?? '0') ?? 0;
        final int taskCount = int.tryParse(project['taskCount'] ?? '0') ?? 0;
        final int totalTasks = int.tryParse(project['totalTasks'] ?? '0') ?? 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project['title'] ?? "No Title", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(project['startDate'] ?? "-", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 10),
                  const Text(" - - - "),
                  const SizedBox(width: 10),
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(project['endDate'] ?? "-", style: GoogleFonts.poppins(fontSize: 12, color: Colors.deepOrange)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: purple,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "$taskCount/$totalTasks tasks",
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTaskSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: tasks,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final taskList = snapshot.data!;
        return Column(
          children: taskList
              .map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: buildTaskItem(task['title'], task['deadline']),
          ))
              .toList(),
        );
      },
    );
  }


  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Dashboard",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          backgroundColor: purple,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
          Icon(Icons.tune, color: Colors.grey),
        ],
      ),
    );
  }

  Widget buildTabs() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: purple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Overview",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Analytics",
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildBottomNavBar() {
    return   BottomNavigationBar(
    backgroundColor: Colors.white,
    selectedItemColor: purple,
    unselectedItemColor: Colors.grey,
    items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ""),
    ],
    );
  }
  Widget buildTaskItem(String title, String deadline) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.widgets, color: Colors.grey),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              Text("Deadline: $deadline", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}
