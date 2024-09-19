import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
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
    Get.offNamed(Approute.login);
  }

  void deleteAccount(int adminId) async {
  try {
    var response = await DioClient().GetInstance().delete('/admin/$adminId');
    if (response.statusCode == 200) {
      showsuccessdialog(Get.context!, "Admin deleted successfully", "", () {
        Get.offNamed("/register");
      });
    } else {
      print("Error deleting admin: ${response.data}");
      showsuccessdialog(Get.context!, "Error", "Failed to delete admin.", () {});
    }
  } catch (e) {
    print("Error: $e");
    showsuccessdialog(Get.context!, "Error", "An unexpected error occurred.", () {});
  }
}

}
