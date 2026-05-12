import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  // ================= CONTROLLERS =================
  final TextEditingController titleController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController expController = TextEditingController();

  // ================= VALUES =================
  String title = "";
  String difficulty = "";
  String exp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Life RPG Form"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= TITLE =================
            const Text(
              "Tên nhiệm vụ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,

              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },

              decoration: InputDecoration(
                hintText: "Nhập tên nhiệm vụ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= DIFFICULTY =================
            const Text(
              "Độ khó",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: difficultyController,

              onChanged: (value) {
                setState(() {
                  difficulty = value;
                });
              },

              decoration: InputDecoration(
                hintText: "Easy / Medium / Hard",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= EXP =================
            const Text(
              "EXP Reward",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: expController,

              onChanged: (value) {
                setState(() {
                  exp = value;
                });
              },

              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                hintText: "Nhập EXP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================= SHOW VALUE =================
            const Text(
              "Dữ liệu lấy từ TextField:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Task Title: $title"),
            Text("Difficulty: $difficulty"),
            Text("EXP: $exp"),
          ],
        ),
      ),
    );
  }
}