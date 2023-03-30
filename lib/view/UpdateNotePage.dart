import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/UpdateController.dart';

class UpdateNotePage extends StatelessWidget {
  //we will need to get the document id once the user is want to naviage to this page.
  final documentId;
  UpdateNotePage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    //by this way we will pass the doucmentid to the controller because of it will need it.
    //if i declare it before of the "build" method it's going to casue an error.
    final controller = Get.put(UpdateNoteControler(documentId: documentId));
    return
        //We wrap our scaffold with gestureDetector,so that when the user  click on any part of the screen out of the t
        //textfield ,the keypoard will dismess.
        GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "28".tr,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Colors.blue,
          // foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Form(
              key: controller.myFormKey,
              child: Column(
                children: [
                  GetBuilder<UpdateNoteControler>(builder: (controller) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: controller.titleNote,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(controller.noteFocus);
                          },
                          validator: (value) {
                            return controller.isEmptyValidator(value);
                          },
                          maxLength: 30,
                          decoration: InputDecoration(
                              labelText: "15".tr,
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.note),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                        ),
                        TextFormField(
                          controller: controller.noteBode,
                          validator: (value) {
                            return controller.isEmptyValidator(value);
                          },
                          // maxLines: 3,
                          maxLength: 200,
                          //This to make when the user submit on the first text field he will auto be take
                          //this text field.(Note textField.)
                          focusNode: controller.noteFocus,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              labelText: "16".tr,
                              prefixIcon: Icon(Icons.note),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                        ),
                      ],
                    );
                  }),
                  ElevatedButton(
                    onPressed: () {
                      Get.bottomSheet(
                          backgroundColor: Colors.white,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  child: Text(
                                "23".tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              )),
                              ListTile(
                                title: Text("24".tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                onTap: () {
                                  controller.EditImageFromGellary();
                                  Navigator.of(context).pop();
                                },
                                leading: Icon(
                                  Icons.image,
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                title: Text("25".tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                onTap: () {
                                  controller.EditImageFromCamera();
                                  Navigator.of(context).pop();
                                },
                                leading: Icon(
                                  Icons.camera,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ));
                    },
                    child: Text("29".tr),
                    style: ElevatedButton.styleFrom(),
                  ),
                  Container(
                    width: 300.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.updateNoteButton(documentId, context);
                      },
                      child: Text(
                        "28".tr,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      style: ElevatedButton.styleFrom(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
