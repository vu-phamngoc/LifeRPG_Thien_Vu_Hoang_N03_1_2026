import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff5f5f5),
      child: Column(
        children: [
          // NAVBAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Life RPG",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                Row(
                  children: const [
                    Text("Products"),
                    SizedBox(width: 20),
                    Text("Solutions"),
                    SizedBox(width: 20),
                    Text("Community"),
                    SizedBox(width: 20),
                    Text("Contact"),
                  ],
                ),

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

          const SizedBox(height: 100),

          // HERO
          const Text(
            "Life RPG",
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          const Text(
            "Gamified Task Management for Kids",
            style: TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}