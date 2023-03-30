// Importing required packages
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:note_taking_tpp3/controller/SignUpController.dart';
import 'package:note_taking_tpp3/view/Login.dart';

// Creating a stateful widget for SignUp screen
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

// Implementing the state of the SignUp screen
class _SignUpState extends State<SignUp> {
  // Creating an instance of SignUpController
  final SignUpController controller = Get.put(SignUpController());
  // Creating a form key for validation and submission
  final myFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismissing the keyboard when tapped outside the text fields
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      // Creating the layout for SignUp screen
      child: Scaffold(
        body: Form(
          key: myFormKey,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Displaying the app logo
                      const Image(image: AssetImage("assets/note_logo.jpg")),
                      // Using the SignUpController for handling the state of text fields
                      GetBuilder<SignUpController>(builder: (controller) {
                        return Column(
                          children: [
                            // Creating a text field for user name
                            TextFormField(
                              controller: controller.userNameController,
                              // Setting the focus to the password field when user hits submit
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(controller.passFocus);
                              },
                              // Validating the input for user name
                              validator: (value) {
                                return controller.isEmpty(value);
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: "8".tr,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(
                              
                              height: MediaQuery.of(context).size.height / 100,
                            ),
                            // Creating a text field for password
                            TextFormField(
                              focusNode: controller.passFocus,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(controller.varfPassFocus);
                              },
                              controller: controller.passController,
                              // Validating the input for password
                              validator: (value) {
                                return controller.passValidator(value);
                              },
                              obscureText: controller.obSecureVal,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_open),
                                hintText: "3".tr,
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  // Setting the visibility of password
                                  icon: Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    setState(() {
                                      controller.obSecureVal =
                                          !controller.obSecureVal;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 100),
                            // Creating a text field for password verification
                            TextFormField(
                              focusNode: controller.varfPassFocus,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(controller.emailFocus);
                              },
                              // Validating the input for password verification
                              validator: (value) {
                                return controller
                                    .passVarificationValidation(value);
                              },
                              obscureText: controller.obSecureValVarify,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_open),
                                hintText: "10".tr,
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    setState(() {
                                      controller.obSecureValVarify =
                                          !controller.obSecureValVarify;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 100),
                            TextFormField(
                              focusNode: controller.emailFocus,
                              controller: controller.emilController,
                              keyboardType: TextInputType.emailAddress,
                              //عشان نتحقق من الاسميمل المدخل دة هو ايميل صحيح او ايميل صالح انو يكون ايميل
                              validator: (value) {
                                return controller.emailValidator(value);
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: "2".tr,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 100),
                          ],
                        );
                      }),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text("11".tr),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Get.back();
                                });
                              },
                              child: Text(
                                "5".tr,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100),
                      Container(
                          width: 200.w,
                          child: ElevatedButton(
                              onPressed: () async {
                                controller.singUp(context, myFormKey);
                              },
                              child: Text("12".tr)))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
