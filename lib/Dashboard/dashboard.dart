import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasker_by_team_dsa/Dashboard/project_detail_screen.dart';

import 'create_project_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final purple = const Color(0xFF6C4DFE);
  late Future<List<Map<String, dynamic>>> projects;
  late Future<List<Map<String, dynamic>>> tasks;
  int selectedTabIndex = 0;
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
              if (selectedTabIndex == 0) ...[
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
              ] else ...[
                buildAnalyticsSection(),
              ],

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

        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProjectDetailScreen(project: {
                  'title': 'UI Redesign',
                  'descr  iption': 'Redesign the mobile app interface with modern UI principles.',
                  'startDate': '2025-03-01',
                  'endDate': '2025-04-15',
                  'status': 'In Progress',
                  'progress': '0.65',
                }),
              ),
            );
          },
          child: Container(
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
        PopupMenuButton<String>(
          onSelected: (value) {

            if (value == 'new_project') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CreateProjectScreen())
              );

            } else if (value == 'new_task') {

            } else if (value == 'import_data') {

            } else if (value == 'settings') {

            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'new_project',
              child: Row(
                children: [
                  Icon(Icons.work_outline, color: Colors.black54),
                  SizedBox(width: 10),
                  Text("New Project"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'new_task',
              child: Row(
                children: [
                  Icon(Icons.task_alt_outlined, color: Colors.black54),
                  SizedBox(width: 10),
                  Text("New Task"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'import_data',
              child: Row(
                children: [
                  Icon(Icons.upload_file, color: Colors.black54),
                  SizedBox(width: 10),
                  Text("Import Data"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, color: Colors.black54),
                  SizedBox(width: 10),
                  Text("Settings"),
                ],
              ),
            ),
          ],

          child: CircleAvatar(
            backgroundColor: purple,
            child: const Icon(Icons.add, color: Colors.white),
          ),
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
        GestureDetector(
          onTap: () => setState(() => selectedTabIndex = 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: selectedTabIndex == 0 ? purple : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Overview",
              style: GoogleFonts.poppins(
                color: selectedTabIndex == 0 ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => setState(() => selectedTabIndex = 1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: selectedTabIndex == 1 ? purple : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Analytics",
              style: GoogleFonts.poppins(
                color: selectedTabIndex == 1 ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget buildAnalyticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Project Progress", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ["Mon", "Tue", "Wed", "Thu", "Fri"];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(titles[value.toInt() % titles.length],
                              style: GoogleFonts.poppins(fontSize: 12)),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: purple)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 7, color: purple)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 6, color: purple)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 8, color: purple)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 4, color: purple)]),
                ],
              ),
            ),
          ),
        ],
      ),
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
