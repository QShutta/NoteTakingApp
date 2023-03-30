import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

//This page i will not use the getx in it ,because of there is no code in it,it's just desing.
//so i think ther is no need for createing a controller and all of this staff

//it appears that you are correct in that there is no need to create a separate controller class
// since there is no dynamic logic or data manipulation taking place in this page.
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
          title: Text("39".tr),
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
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
              // height: 10.h,
              //قسمنا ارتفاع الشاشة علي 30 جزء وادينا
              //height جزء من الاجزاء دي
              //عشان نضمن انو المسافة حتكون واحد في كل الشاشاات .
              height: MediaQuery.of(context).size.height / 30,
            ),
            Container(
              // margin: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    // color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    // height: 10,
                    height: MediaQuery.of(context).size.height / 100,
                  ),
                  Container(
                    width: double.infinity,
                    // color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 20),
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
    }
  }
}
