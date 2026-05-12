import 'package:flutter/material.dart';
import 'package:flutter_application/front/screens/home_screen.dart';
import 'package:flutter_application/front/screens/form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _currentIndex = 0;

  // ================= DATA =================
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Học Flutter",
      "difficulty": "Easy",
      "expReward": 50,
      "isCompleted": false,
    }
  ];

  Map<String, dynamic> users = {
    "name": "Phạm Ngọc Vũ",
    "exp": 120,
    "level": 2,
  };

  void checkLevelUp() {
    if (users['exp'] >= 200) {
      users['level'] += 1;
      users['exp'] = 0;
    }
  }

  // ================= CONTENT =================
  Widget contentTab() {
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
              "Task Management",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            ...tasks.map((task) => buildContentItem(task)).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildContentItem(Map<String, dynamic> task) {
    return Container(
      width: 800,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            color: Colors.grey.shade300,
            child: const Icon(Icons.image),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['title'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),

                Text("Difficulty: ${task['difficulty']}",
                    style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 10),

                task['isCompleted']
                    ? const Text("Completed ✅",
                        style: TextStyle(color: Colors.green))
                    : OutlinedButton(
                        onPressed: () {
                          setState(() {
                            task['isCompleted'] = true;
                            users['exp'] += task['expReward'];
                            checkLevelUp();
                          });
                        },
                        child: const Text("Start"),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= ABOUT =================
  Widget aboutTab() {
    return Container(
      color: const Color(0xfff5f5f5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),

            const Text(
              "Life RPG",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Contact / About Project",
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
                children: [
                  buildInput("Name"),
                  buildInput("Surname"),
                  buildInput("Email"),
                  buildInput("Message", maxLines: 3),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2d2d2d),
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () {},
                      child: const Text("Submit"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInput(String label, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 5),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: "Value",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      const HomeScreen(),
      contentTab(),
      aboutTab(),
    ];

    return Scaffold(
      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Content"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
      ),
    );
  }
}