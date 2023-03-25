import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_tpp3/HomeFirebase.dart';

import 'package:note_taking_tpp3/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_taking_tpp3/Test.dart';

// import 'firebase_options.dart';
bool? isLogin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  //if the value of the user==null:that means the user is not login with  us.
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white)),
            useMaterial3: true),
        // home: NoteDetailPage(
        //   imageUrl:
        //       'https://thumbs.dreamstime.com/b/lonely-elephant-against-sunset-beautiful-sun-clouds-savannah-serengeti-national-park-africa-tanzania-artistic-imag-image-106950644.jpg',
        //   subtitle: 'al;sdkfj;a sld;fkajs;l dfikalsdkfapso dlkf ',
        //   title: 'TestView',
        // ));
        home: isLogin == true ? HomeFirebase() : Login());
  }
}
