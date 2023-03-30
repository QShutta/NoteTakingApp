import 'dart:ui';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class HomeController extends GetxController {
  

  //المتغير دة مستخدمنو عشان نغير اتجاة الكتباة من اليمين لليسار والعكس
  //The default of it is left to right,then when the user hit the button ,the direction will change.
  late TextDirection mytextDirection = TextDirection.ltr;
//instance from the notes collection
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");
}
