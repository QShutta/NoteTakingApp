import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:note_taking_tpp3/controller/AddNoteController.dart';
import 'package:flutter/material.dart';

class AddNote extends StatelessWidget {
  final controller = Get.put(AddNoteController());

  @override
  Widget build(BuildContext context) {
    return
        //We wrap our scaffold with gestureDetector,so that when the user  click on any part of the screen out of the t
        //textfield ,the keypoard will dismess.
        GestureDetector(
      onTap: () {
        //This when the user click in any part on the screen the focus will be taken fromt the
        //textfield.
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "18".tr,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.sp),
          ),
        ),
        body: ListView(
          children: [
            Form(
              key: controller.myFormKey,
              child: Column(
                children: [
                  //We wrap just the textformField with getBuilder why?Because the change in the ui happen
                  //just in these tow widgets.
                  GetBuilder<AddNoteController>(builder: (controller) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: controller.titleNote,
                          onFieldSubmitted: (value) {
                            //move the focus to the next textformField
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
                                controller.addImageFromGellary();
                                //When the user add image,the bottomsheet will hide by this line
                                Get.back();
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
                                controller.addImageFromCamera();
                                //When the user add image,the bottomsheet will hide by this line
                                Get.back();
                              },
                              leading: Icon(
                                Icons.camera,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                    child: Text("17".tr),
                    style: ElevatedButton.styleFrom(),
                  ),
                  Container(
                    width: 300.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.AddNoteButton(context);
                      },
                      child: Text(
                        "18".tr,
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
