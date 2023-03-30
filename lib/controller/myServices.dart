import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myServices extends GetxService {
  late SharedPreferences sharePref;

 Future init() async {
    sharePref = await SharedPreferences.getInstance();
    return this;
  }
}
