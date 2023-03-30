import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_taking_tpp3/main.dart';

import '../view/Home.dart';

class LoginController extends GetxController {
  bool obSecureVal = true;
  // final myFormKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
//This to be able to get the user to the pass text field when he hit next button.
  var passFocus = FocusNode();

/*The showloading method creates and displays a dialog box with a circular progress indicator,
 indicating that some loading or processing operation is currently underway.
  This method is called before attempting to sign in the user with Firebase authentication.
   The dialog box is displayed to the user to
 indicate that the authentication process is currently underway and the user should wait until it's complete. */
  showloading(BuildContext context) {
    showDialog(
        context: context,
        builder: (i) {
          return AlertDialog(
            title: Center(child: CircularProgressIndicator()),
          );
        });
  }

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
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    sharePref!.setString("ID", userCredential.user!.uid);

    // Once signed in, return the UserCredential
    //new codexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    // return await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  mySignInButton(BuildContext context, GlobalKey<FormState> myFormKey) async {
    //This if condition to make sure that the fields are filled correctly.
    if (myFormKey.currentState!.validate()) {
      try {
        showloading(context); // displays the loading dialog
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: userNameController.text, password: passController.text);
        if (credential.user!.emailVerified == true) {
          //this to put in the cach the user id,so that if he login again he will direcly be taken to the home page.
          //and we will use it with middleWare.
          sharePref!.setString("id", credential.user!.uid);
          //لو الايميل معملول عليهو تاكيد حيسمح ليهو بالانتقال للصفحة التانية
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (builder) {
            return Home();
          }));
        } else {
          //لو الايميل ما  معملول عليهو تاكيد ما  حيسمح ليهو بالانتقال للصفحة التانية
          Navigator.pop(context); // dismisses the loading dialog
          AwesomeDialog(
            btnOkColor: Colors.red,
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.warning,
            body: Center(
              child: Text(
                '32'.tr,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            title: 'Warning',
            btnOkOnPress: () {},
          )..show(); // displays the awesome dialog
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // dismisses the loading dialog
        //المتغير دة حنخزن فيهو الرسالة بتاعت الخطا
        String errorMessage = '';
        if (e.code == 'user-not-found') {
          errorMessage = '30'.tr;
        } else if (e.code == 'wrong-password') {
          errorMessage = '31'.tr;
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
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Error',
          btnOkOnPress: () {},
        )..show(); // displays the awesome dialog
      }
    }
  }

  String? emailValidator(value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp rg = new RegExp(pattern);
    if (rg.hasMatch(value.toString())) {
      return null;
    } else if (value == null || value == "") {
      return "26".tr;
    } else {
      return "33".tr;
    }
  }

//value بتمثل ليك قيمة النص القاعد في التكست فيلد
  String? isEmpty(value) {
    if (value == null || value == "") {
      return "26".tr;
    }
    return null;
  }
}
