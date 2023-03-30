import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_tpp3/controller/Themes.dart';
import 'package:note_taking_tpp3/controller/middleWare.dart';
import 'package:note_taking_tpp3/view/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_taking_tpp3/view/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/LanguageController.dart';
import 'controller/LoginController.dart';
import 'controller/myLocal.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'firebase_options.dart';
bool? isLogin;
//I will create an instance of the shared prefrenced here so it will be accessable any where in the app.
SharedPreferences? sharePref;
//المتغير دة بمثل ليك  الثيم بتاع التطبيق
ThemeData? initalTheme;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blue, // change the color of the status bar
  ));
  await Firebase.initializeApp();
  // await initlizeServices();
  sharePref = await SharedPreferences.getInstance();
  //Theme code Start.
  //If the user doesn't select any mode the isDark var will set to false that mean's it will set to light mode.
  bool isDark = sharePref!.getBool("isDark") ?? false;
  initalTheme = isDark ? myTheme.darkTheme : myTheme.lightTheme;
//Theme code End.
  runApp(MyApp());
  // To use device preview.to test on more than one device.
  //When using the desing preview will cause an error in the app barr you don't have to give a shit about it alot.
  // runApp(DevicePreview(builder: (context) {
  //   return MyApp();
  // }));
}

class MyApp extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final LanguageController LangController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          translations: localization(),
          locale: LangController.initalLang,
          debugShowCheckedModeBanner: false,
          theme: initalTheme,
          //We use the middleWare to redirect the user if he login to the
          getPages: [
            GetPage(
                name: "/", page: () => Login(), middlewares: [myMidleWare()]),
            GetPage(name: "/Home", page: () => Home())
          ],
        );
      },
    );
  }
}
