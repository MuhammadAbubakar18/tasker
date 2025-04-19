import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Map<String, String> project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final purple = const Color(0xFF6C4DFE);

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final double progress = double.tryParse(project['progress'] ?? '0.0') ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        title: Text("Project Details", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              project['title'] ?? '',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),


            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  "${project['startDate']} - ${project['endDate']}",
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),


            Text("Description", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(
              project['description'] ?? "No description provided.",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),


            Text("Progress", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: purple,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text("${(progress * 100).toStringAsFixed(0)}% completed", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),

            const SizedBox(height: 30),


            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.grey),
                const SizedBox(width: 5),
                Text("Status: ", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                Text(
                  project['status'] ?? 'N/A',
                  style: GoogleFonts.poppins(color: Colors.green.shade700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
