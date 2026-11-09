
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
            const Text(
              "Welcome User",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            const TextField(
              decoration: InputDecoration(
                hintText: "Masukin Nama",
                labelText: "Nama Lengkap",
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Masukin Password",
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.badge,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

