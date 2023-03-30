import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController emilController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  var obSecureVal = true;
  var obSecureValVarify = true;
  //what is the use of this var?
  //حاستخدمو عشان اخزن فيهو قيمة التكست فيلد الخاص بي كلمة المرورو وبعدين استخدمو عشان اقارن التطابق بين كلمات المرور
  var passTextVal = "";
  // final myFormKey = GlobalKey<FormState>();
//المتغيرات دي عشان لمن المستخدم ينتهي من الكتابة ويضغط علي الزر يقوم يقدر ينتقل من مربع نص لي اخر ,اللهو البعدو
  var passFocus = FocusNode();
  var varfPassFocus = FocusNode();
  var emailFocus = FocusNode();
  var fireStore = FirebaseFirestore.instance;
  showloading(BuildContext context) {
    showDialog(
        context: context,
        builder: (i) {
          return AlertDialog(
            title: Center(child: CircularProgressIndicator()),
          );
        });
  }

  String? emailValidator(value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp rg = new RegExp(pattern);
    if (rg.hasMatch(value.toString())) {
      //لو صالح حيرجع نل
      return null;
    } else {
      //غير كدة حيرجع ايرور
      return "33".tr;
    }
  }

  String? isEmpty(value) {
    if (value == null || value == "") {
      return "26".tr;
    }
    return null;
  }

  String? passValidator(value) {
    // This line returns null indicating that the input is valid.
    // This line defines a validator function that takes a value.
    //حاستخدمو عشان اخزن فيهو قيمة التكست فيلد الخاص بي كلمة المرورو وبعدين استخدمو عشان اقارن التطابق بين كلمات المرور
    passTextVal = value.toString();
    // This line updates the password controller's text value to the current value entered by the user.
    if (value == null || value == "") {
      // This line checks if the value is empty or null.
      return "26".tr; // This line returns an error message if the value is empty or null.
    }
    return null;
  }

//الدالة دي مستخدمها من اجل التاكد من انو النص بتاع التكست فيد ما فاضي وبرضو عشان اتاكد من انو كلمتين
//السر متطابقات )(المستخدم حيدخل كلمة سر,وتاكيد لي كلمة السر,فهنا نحنا حنتاكد من انهم متطابقات)
  String? passVarificationValidation(value) {
    if (value == null ||
        value == "" ||
        //passTextVal:
        //حاستخدمو عشان اخزن فيهو قيمة التكست فيلد الخاص بي كلمة المرورو وبعدين استخدمو عشان اقارن التطابق بين كلمات المرور
        value != passTextVal) {
      return "35".tr;
    }
    return null;
  }

  singUp(BuildContext context, GlobalKey<FormState> myFormKey) async {
    //This to make sure that the textfields are filled correctly.
    if (myFormKey.currentState!.validate()) {
      try {
        showloading(context);
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emilController.text,
          password: passController.text,
        );

        if (credential.user!.emailVerified == false) {
          User? user = FirebaseAuth.instance.currentUser;
          await user!.sendEmailVerification();
          //There is an alert should apear here to tell the user that
          //there is a varfication email has been send to him.
        }
        fireStore.collection("userName").add({
          "userName": "$userNameController.text}",
          "email": "${emilController.text}"
        });
        //This to discard from the loading
        Navigator.of(context).pop();
        //This to return to the previous page,(Login page).
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                content: Icon(Icons.check),
                actions: [
                  Text(
                    "36".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  )
                ],
              );
            });
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'weak-password') {
          Get.snackbar("Warring", "37".tr,
              backgroundColor: Colors.red);
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Warring", "38".tr,
              backgroundColor: Colors.red);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
