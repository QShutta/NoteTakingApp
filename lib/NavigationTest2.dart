import 'package:flutter/material.dart';

class TestNav2 extends StatefulWidget {
  const TestNav2({super.key});

  @override
  State<TestNav2> createState() => _TestNav2State();
}

class _TestNav2State extends State<TestNav2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secound  Page"),
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Pop"),
      ),
    );
  }
}
