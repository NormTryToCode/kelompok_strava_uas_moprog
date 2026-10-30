import 'package:flutter/material.dart';

class GroupsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Challenges"),
              Text("Clubs"),
              Text("Events")
            ],
          )
        ) 
      )
    );
  }
}