import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:note_taking_tpp3/main.dart';

class myMidleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // TODO: implement redirect
    if (sharePref!.getString("ID") != null) return RouteSettings(name: "/Home");
    return null;
  }
}
