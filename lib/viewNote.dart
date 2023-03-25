import 'package:flutter/material.dart';

class viewNote extends StatefulWidget {
  final title;
  final note;
  final ImageUrl;

  const viewNote(
      {required this.note,
      required this.title,
      required this.ImageUrl,
      super.key});

  @override
  State<viewNote> createState() => _viewNoteState();
}

class _viewNoteState extends State<viewNote> {
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text("View Note"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                widget.ImageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // margin: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    // color: Colors.red,
                    margin: EdgeInsets.only(left: 17),
                    child: Text(
                      widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    // color: Colors.red,
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      widget.title,
                      style: TextStyle(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } catch (e) {
      return Text("$e");
      print("$e");
    }
  }
}
