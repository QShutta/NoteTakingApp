import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:note_taking_tpp3/Login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emilController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  var obSecureVal = true;
  var obSecureValVarify = true;
  var passTextVal = "";
  final myFormKey = GlobalKey<FormState>();
//المتغيرات دي عشان لمن المستخدم ينتهي من الكتابة ويضغط علي الزر يقوم يقدر ينتقل من مربع نص لي اخر ,اللهو البعدو
  var passFocus = FocusNode();
  var varfPassFocus = FocusNode();
  var emailFocus = FocusNode();
  var fireStore = FirebaseFirestore.instance;
  showloading() {
    showDialog(
        context: context,
        builder: (i) {
          return AlertDialog(
            title: Center(child: CircularProgressIndicator()),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                      const Image(image: AssetImage("assets/note_logo.jpg")),
                      TextFormField(
                        controller: userNameController,
                        //We said to him when the user hit the submit button,take him to the next textfield.
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(passFocus);
                        },
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This Field Can't Be empty";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "username",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: passFocus,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(varfPassFocus);
                        },
                        controller: passController,
                        validator: (value) {
                          passTextVal = value.toString();
                          if (value == null || value == "") {
                            return "This Field Can't Be empty";
                          }
                          return null;
                        },
                        obscureText: obSecureVal,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_open),
                          hintText: "password",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                obSecureVal = !obSecureVal;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: varfPassFocus,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(emailFocus);
                        },
                        validator: (value) {
                          if (value == null ||
                              value == "" ||
                              value != passTextVal) {
                            return "This Field Can't Be empty&The tow passwerds should be match";
                          }
                          return null;
                        },
                        obscureText: obSecureValVarify,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_open),
                          hintText: "Varify Password",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                obSecureValVarify = !obSecureValVarify;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: emailFocus,
                        controller: emilController,
                        keyboardType: TextInputType.emailAddress,
                        //عشان نتحقق من الاسميمل المدخل دة هو ايميل صحيح او ايميل صالح انو يكون ايميل
                        validator: (value) {
                          String pattern =
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          RegExp rg = new RegExp(pattern);
                          if (rg.hasMatch(value.toString())) {
                            //لو صالح حيرجع نل
                            return null;
                          } else {
                            //غير كدة حيرجع ايرور
                            return "This is not a valid  emil addrass";
                          }
                        },
                        obscureText: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text("If you haven acount"),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                  // Navigator.of(context)
                                  //     .push(MaterialPageRoute(builder: (builder) {
                                  //   return Login();
                                  // }));
                                });
                              },
                              child: const Text(
                                "Click Here",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                //This to make sure that the textfields are filled correctly.
                                if (myFormKey.currentState!.validate()) {
                                  try {
                                    showloading();
                                    final credential = await FirebaseAuth
                                        .instance
                                        .createUserWithEmailAndPassword(
                                      email: emilController.text,
                                      password: passController.text,
                                    );

                                    if (credential.user!.emailVerified ==
                                        false) {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      await user!.sendEmailVerification();
                                      //There is an alert should apear here to tell the user that
                                      //there is a varfication email has been send to him.
                                    }
                                    fireStore.collection("userName").add({
                                      "userName": "${userNameController.text}",
                                      "email": "${emilController.text}"
                                    });
                                    //This to discard from the loading
                                    Navigator.of(context).pop();
                                    //This to return to the previous page,(Login page).
                                    Navigator.of(context).pop();

                                    // AwesomeDialog(
                                    //   btnOkColor: Colors.blue,
                                    //   btnCancelColor: Colors.grey,
                                    //   context: context,
                                    //   animType: AnimType.scale,
                                    //   dialogType: DialogType.success,
                                    //   body: Center(
                                    //     child: Text(
                                    //       'Verification email sent! Please check your inbox and spam folder for further instructions',
                                    //       style: TextStyle(
                                    //           fontStyle: FontStyle.italic),
                                    //     ),
                                    //   ),
                                    //   title: "Success",
                                    //   btnOkOnPress: () {
                                    //     Navigator.of(context).pop();
                                    //   },
                                    // )..show();

                                    showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return AlertDialog(
                                            content: Icon(Icons.check),
                                            actions: [
                                              Text(
                                                "Verification email sent! Please check your inbox and spam folder for further instructions",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(),
                                              )
                                            ],
                                          );
                                        });
                                  } on FirebaseAuthException catch (e) {
                                    Navigator.of(context).pop();
                                    if (e.code == 'weak-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'The password provided is too weak.'),
                                        ),
                                      );
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'The account already exists for that email.'),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                  // Navigator.of(context).pop();
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (builder) {
                                  //       return AlertDialog(
                                  //         content: Icon(Icons.check),
                                  //       );
                                  //     });
                                }
                              },
                              child: Text("SignUp")))
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
