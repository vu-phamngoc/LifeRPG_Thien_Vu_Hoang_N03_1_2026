import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ================= CONTROLLER =================
  final TextEditingController taskController = TextEditingController();
  final TextEditingController difficultyController =
      TextEditingController();

  // ================= VALUE =================
  String taskName = "";
  String difficulty = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= NAVBAR =================
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // LOGO
                  const Text(
                    "Life RPG",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // MENU
                  Row(
                    children: const [
                      Text("Tasks"),
                      SizedBox(width: 20),
                      Text("Rewards"),
                      SizedBox(width: 20),
                      Text("Leaderboard"),
                      SizedBox(width: 20),
                      Text("About"),
                    ],
                  ),

                  // BUTTON
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Sign in"),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text("Register"),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 60),

            // ================= HERO =================
            const Text(
              "Life RPG",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Gamified Task Management For Kids",
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 50),

            // ================= FORM =================
            Container(
              width: 450,
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Create Task",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= TASK NAME =================
                  const Text(
                    "Task Name",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: taskController,

                    onChanged: (value) {
                      setState(() {
                        taskName = value;
                      });
                    },

                    decoration: InputDecoration(
                      hintText: "Enter task name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= DIFFICULTY =================
                  const Text(
                    "Difficulty",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
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

                  const SizedBox(height: 30),

                  // ================= BUTTON =================
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(16),
                      ),

                      onPressed: () {},

                      child: const Text(
                        "Save Task",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= SHOW VALUE =================
                  const Text(
                    "Live Data",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text("Task Name: $taskName"),
                  Text("Difficulty: $difficulty"),
                ],
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}