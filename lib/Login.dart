import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_taking_tpp3/SignUp.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'HomeFirebase.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  bool obSecureVal = true;
  final myFormKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
//This to be able to get the user to the pass text field when he hit next button.
  var passFocus = FocusNode();
/*The showloading method creates and displays a dialog box with a circular progress indicator,
 indicating that some loading or processing operation is currently underway.
  This method is called before attempting to sign in the user with Firebase authentication.
   The dialog box is displayed to the user to
 indicate that the authentication process is currently underway and the user should wait until it's complete. */
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
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: myFormKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage("assets/note_logo.jpg")),
                    TextFormField(
                      //عشان نتحقق من الاسميمل المدخل دة هو ايميل صحيح او ايميل صالح انو يكون ايميل
                      validator: (value) {
                        String pattern =
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        RegExp rg = new RegExp(pattern);
                        if (rg.hasMatch(value.toString())) {
                          //لو صالح حيرجع نل
                          return null;
                        } else if (value == null || value == "") {
                          return "This Field Can't Be empty";
                        } else {
                          //غير كدة حيرجع ايرور
                          return "This is not a valid  emil addrass";
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(passFocus);
                      },
                      controller: userNameController,
                      // validator: (value) {
                      //   if (value == null || value == "") {
                      //     return "This Field Can't Be empty";
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: passFocus,
                      controller: passController,
                      validator: (value) {
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
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text("If you haven't acount"),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (builder) {
                                return const SignUp();
                              }));
                              userNameController.clear();
                              passController.clear();
                            },
                            child: Text(
                              "Click Here",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async {
                          //This if condition to make sure that the fields are filled correctly.
                          if (myFormKey.currentState!.validate()) {
                            try {
                              showloading(); // displays the loading dialog
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: userNameController.text,
                                      password: passController.text);
                              if (credential.user!.emailVerified == true) {
                                //لو الايميل معملول عليهو تاكيد حيسمح ليهو بالانتقال للصفحة التانية
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (builder) {
                                  return HomeFirebase();
                                }));
                              } else {
                                //لو الايميل ما  معملول عليهو تاكيد ما  حيسمح ليهو بالانتقال للصفحة التانية
                                Navigator.pop(
                                    context); // dismisses the loading dialog
                                AwesomeDialog(
                                  btnOkColor: Colors.red,
                                  context: context,
                                  animType: AnimType.scale,
                                  dialogType: DialogType.warning,
                                  body: Center(
                                    child: Text(
                                      'Verify your email first',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  title: 'Warning',
                                  btnOkOnPress: () {},
                                )..show(); // displays the awesome dialog
                              }
                            } on FirebaseAuthException catch (e) {
                              Navigator.pop(
                                  context); // dismisses the loading dialog
                              //المتغير دة حنخزن فيهو الرسالة بتاعت الخطا
                              String errorMessage = '';
                              if (e.code == 'user-not-found') {
                                errorMessage = 'no user found for this email';
                              } else if (e.code == 'wrong-password') {
                                errorMessage = 'email or pass are incorrect';
                              } else {
                                errorMessage = e.message!;
                              }
                              AwesomeDialog(
                                btnOkColor: Colors.red,
                                context: context,
                                animType: AnimType.scale,
                                dialogType: DialogType.error,
                                body: Center(
                                  child: Text(
                                    errorMessage,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                title: 'Error',
                                btnOkOnPress: () {},
                              )..show(); // displays the awesome dialog
                            }
                          }
                        },
                        child: Text("Login"),
                      ),
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        try {
                          showloading();
                          await signInWithGoogle();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (builder) {
                            return HomeFirebase();
                          }));
                        } catch (e) {
                          //we want to replace the scaffoldMessanger with aweasome dialog.
                          //Because of the snack bar doesn't apear in some phones

                          //This to hid the alert loading dialog and replace it by the aweasome
                          Navigator.pop(context);

                          AwesomeDialog(
                            btnOkColor: Colors.red,
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.error,
                            body: Center(
                              child: Text(
                                '$e',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            title: 'Warring',
                            btnOkOnPress: () {},
                          )..show();
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text('$e'),
                          //     ),
                          //   );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
 ElevatedButton(
                        onPressed: () async {
                          //This if condition to make sure that the fields are filled correctly.
                          if (myFormKey.currentState!.validate()) {
                            try {
                              showloading(); // displays the loading dialog
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: userNameController.text,
                                      password: passController.text);
                              if (credential.user!.emailVerified == true) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (builder) {
                                  return HomeFirebase();
                                }));
                              } else {
                                Navigator.pop(
                                    context); // dismisses the loading dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('varfy email'),
                                  ),
                                );
                                // AwesomeDialog(
                                //   btnOkColor: Colors.red,
                                //   context: context,
                                //   animType: AnimType.scale,
                                //   dialogType: DialogType.error,
                                //   body: Center(
                                //     child: Text(
                                //       'Verify your email first',
                                //       style: TextStyle(
                                //           fontStyle: FontStyle.italic),
                                //     ),
                                //   ),
                                //   title: 'Warning',
                                //   btnOkOnPress: () {},
                                // )..show(); // displays the awesome dialog
                              }
                            } on FirebaseAuthException catch (e) {
                              Navigator.pop(
                                  context); // dismisses the loading dialog
                              if (e.code == 'user-not-found') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('no user found for this email'),
                                  ),
                                );
                                // AwesomeDialog(
                                //   btnOkColor: Colors.red,
                                //   context: context,
                                //   animType: AnimType.scale,
                                //   dialogType: DialogType.error,
                                //   body: Center(
                                //     child: Text(
                                //       'No user found for that email.',
                                //       style: TextStyle(
                                //           fontStyle: FontStyle.italic),
                                //     ),
                                //   ),
                                //   title: 'Warning',
                                //   btnOkOnPress: () {},
                                // )..show(); // displays the awesome dialog
                              } else if (e.code == 'wrong-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('email or pass are in correct'),
                                  ),
                                );
                                // AwesomeDialog(
                                //   btnOkColor: Colors.red,
                                //   context: context,
                                //   animType: AnimType.scale,
                                //   dialogType: DialogType.error,
                                //   body: Center(
                                //     child: Text(
                                //       'Email or password are incorrect.',
                                //       style: TextStyle(
                                //           fontStyle: FontStyle.italic),
                                //     ),
                                //   ),
                                //   title: 'Warning',
                                //   btnOkOnPress: () {},
                                // )..show(); // displays the awesome dialog
                              }
                            }
                          }
                        },
                        child: Text("Login"),
                      ),*/
