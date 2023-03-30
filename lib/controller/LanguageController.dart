import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LanguageController extends GetxController {
  // declaring a variable to hold the initial language,
  // using the `late` keyword to indicate that it will be initialized later
  late Locale initalLang;
  // declaring a boolean variable to represent whether the language is English or not
  //why did he give the inital value true?
  //Of course, this assumption may not always hold true,
  //as the user may have changed the default language preference of their device. In such cases,
  //the value of isEnglish will be updated accordingly in the onInit() method of the LanguageController class.
  bool isEnglish = true;
  var fontSizeAr = 20;
  var fontSizeEn = 30;
  //unWanted for now
  //المتغير دة عرفناهو عشان في حال انو  اللغة عربي والخط كبير ,نقدر نغير حجم الخط حسب اللغة
  // var titleFontSize = 20.0.obs; // initialize the font size to 30 for English

  @override
  void onInit() {
    // this method is called when the controller is initialized
    super.onInit(); // call the superclass's onInit method first
    // check if the language preference is null

    initalLang = (sharePref!.getString("lang") == null)
        ? Get
            .deviceLocale! // if it's null, use the device's current locale as the initial language
        // otherwise, use the saved language preference as the initial language
        : Locale("${sharePref!.getString("lang")}");
    // set the isEnglish variable based on the initial language's languageCode
    //The line of code compares the languageCode property of initalLang to the string 'en' using the == operator.
    // If the language code is 'en', the expression evaluates to true,
    // and isEnglish is set to true. Otherwise, the expression evaluates to false, and isEnglish is set to false.
    isEnglish = initalLang.languageCode == 'en';
  }

  void changeLang() {
    // a method to change the language
    //if the "isEnglish"==true ,will become false
    isEnglish = !isEnglish; // toggleتبديل the boolean value of isEnglish
    // set the locale variable based on the new value of isEnglish
    Locale locale = isEnglish ? Locale('en') : Locale('ar');
    // save the language preference in shared preferences using the language code
    sharePref!.setString("lang", locale.languageCode);
    // update the app's locale to the newly selected language
    Get.updateLocale(locale);
//unwanter for now
    // // update the title font size based on the new language
    // if (isEnglish) {
    //   titleFontSize.value = 30.sp;
    // } else {
    //   titleFontSize.value = 20.sp;
    // }
  }
}
