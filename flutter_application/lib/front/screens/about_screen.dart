import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff5f5f5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),

            const Text(
              "About",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Parent Management",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            Container(
              width: 360,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: const [
                  TextField(decoration: InputDecoration(labelText: "Name")),
                  SizedBox(height: 10),
                  TextField(decoration: InputDecoration(labelText: "Email")),
                  SizedBox(height: 10),
                  TextField(decoration: InputDecoration(labelText: "Message")),
                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}