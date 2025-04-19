import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final List<Color> labelColors = [Colors.pink[100]!, Colors.orange[100]!, Colors.blue[100]!, Colors.red[100]!];
  Color? selectedLabel;

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF6C4DFE);
    final textStyle = GoogleFonts.poppins(fontSize: 16);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(),
        centerTitle: true,
        title: Text("Create project", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text("Name", style: textStyle),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Text",
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: purple),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: purple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text("Add member", style: textStyle),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(
                  3,
                      (index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/user${index + 1}.jpg"), // Replace with your assets
                      radius: 20,
                    ),
                  ),
                ),
                DottedAvatarButton(),
              ],
            ),
            const SizedBox(height: 20),

            Text("Date and time", style: textStyle),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: DatePickerCircle(label: startDate != null ? DateFormat('MMM d yyyy').format(startDate!) : "Start", color: purple, onTap: () => pickDate(true))),
                const SizedBox(width: 16),
                Expanded(child: DatePickerCircle(label: endDate != null ? DateFormat('MMM d yyyy').format(endDate!) : "End", color: purple.withOpacity(0.8), onTap: () => pickDate(false))),
              ],
            ),
            const SizedBox(height: 20),

            Text("Add label", style: textStyle),
            const SizedBox(height: 8),
            Row(
              children: [
                ...labelColors.map((c) => GestureDetector(
                  onTap: () => setState(() => selectedLabel = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedLabel == c ? purple : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                )),
                DottedAddLabel(),
              ],
            ),
            const SizedBox(height: 20),

            Text("Description", style: textStyle),
            const SizedBox(height: 6),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Text",
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                // Save project logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.arrow_forward),
              label: Text("Create", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerCircle extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DatePickerCircle({super.key, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class DottedAvatarButton extends StatelessWidget {
  const DottedAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, style: BorderStyle.solid, width: 1),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: const Center(child: Icon(Icons.add, color: Colors.purple)),
    );
  }
}

class DottedAddLabel extends StatelessWidget {
  const DottedAddLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, style: BorderStyle.solid),
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Icon(Icons.add, color: Colors.purple, size: 16),
    );
  }
}

