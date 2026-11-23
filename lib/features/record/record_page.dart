import 'package:flutter/material.dart';

class Record extends StatefulWidget {
  const new({super.key});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text("This is the record page")));
  }
}
