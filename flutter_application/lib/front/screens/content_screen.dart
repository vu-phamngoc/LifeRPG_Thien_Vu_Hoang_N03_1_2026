import 'package:flutter/material.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  List<Map<String, dynamic>> tasks = [
    {"title": "Học bài", "status": "pending"},
    {"title": "Rửa bát", "status": "pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff5f5f5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),

            const Text(
              "Content",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Nhiệm vụ của trẻ em",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // CARD
            Container(
              width: 360,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: tasks.map((task) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(task["title"]),
                        task["status"] == "done"
                            ? const Icon(Icons.check, color: Colors.green)
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    task["status"] = "submitted";
                                  });
                                },
                                child: const Text("Submit"),
                              )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}