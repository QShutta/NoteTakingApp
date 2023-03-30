import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_taking_tpp3/view/SignUp.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:note_taking_tpp3/controller/LoginController.dart';
import 'package:note_taking_tpp3/view/Home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image(
                        image: AssetImage("assets/note_logo.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      //We devide the screen height into 100 part,and we set the height to
                      //one of this parts,and then?why?To make the space the same in all the screen sizes.
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    //The change will happen just in tow widgets(the textfield) ,so we will surrond just them
                    //witht he "GetBuilder"
                    GetBuilder<LoginController>(builder: (controller) {
                      //we put the column so that we can put more than one widget in the "getBuilder",this is
                      //the only benfit of
                      return Column(
                        children: [
                          TextFormField(
                            //عشان نتحقق من الاسميمل المدخل دة هو ايميل صحيح او ايميل صالح انو يكون ايميل
                            //value:the value variable represents the current value of the TextFormField.
                            validator: (value) {
                              return controller.emailValidator(value);
                            },

                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(controller.passFocus);
                            },
                            controller: controller.userNameController,

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: "2".tr,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height / 30,
                          ),
                          TextFormField(
                            focusNode: controller.passFocus,
                            controller: controller.passController,
                            validator: (value) {
                              return controller.isEmpty(value);
                            },
                            obscureText: controller.obSecureVal,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_open),
                              hintText: "3".tr,
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
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
                        ],
                      );
                    }),
                    SizedBox(
                      // height: 10,
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text("4".tr),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 100,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(SignUp());
                              controller.userNameController.clear();
                              controller.passController.clear();
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
                      // height: 10,
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Container(
                      width: 150.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          controller.mySignInButton(context, _formKey);
                        },
                        child: Text(
                          "6".tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        try {
                          controller.showloading(context);
                          await controller.signInWithGoogle();

                          Get.off(Home());
                        } catch (e) {
                          //we want to replace the scaffoldMessanger with aweasome dialog.
                          //Because of the snack bar doesn't apear in some phones

                          //This to hid the alert loading dialog and replace it by the aweasome
                          //Alternative in getX
                          Get.back();

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
