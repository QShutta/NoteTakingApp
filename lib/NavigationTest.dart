import 'package:flutter/material.dart';
import 'NavigationTest2.dart';

class TestNav extends StatefulWidget {
  const TestNav({super.key});

  @override
  State<TestNav> createState() => _TestNavState();
}

class _TestNavState extends State<TestNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firs Page"),
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
            return TestNav2();
          }));
        },
        child: Text("Page 2"),
      ),
    );
  }
}
