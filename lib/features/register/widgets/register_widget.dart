import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shell/main_shell.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double cardWidth =
        screenWidth * 0.9 > 400 ? 400 : screenWidth * 0.9;

    return Center(
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        decoration: BoxDecoration(
          color: Styles.accent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_run_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),

            const SizedBox(height: 16),

            const Text(
              "Register As New User",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Text(
                "Start your first step with use",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),

 
            const SizedBox(height: 24),

            const TextField(
              decoration: InputDecoration(
                hintText: "Email",
                labelText: "Cake@gmail.com",
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Name",
                labelText: "Cake",
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),


           const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "New Password",
                labelText: "New Password",
                filled: true,
                fillColor: Colors.white,
              ),
            ),



            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainShell(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.badge,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


