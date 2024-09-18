import 'package:airportadminflutter/routes/AppRoute.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomeController extends GetxController {
  late SharedPreferences prefs;
  late Completer<void> prefsCompleter;

  @override
  void onInit() {
    super.onInit();
    prefsCompleter = Completer<void>();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefsCompleter.complete();
  }

  Future<void> logout() async {
    await prefsCompleter.future;
    prefs.remove("token");
    prefs.remove("name");
    prefs.remove("email");

    print("token");

    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(Approute.login); // Redirect to login page
  }
}
