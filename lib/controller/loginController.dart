import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:airportadminflutter/model/Admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void login(BuildContext context) async {
    print("Login method called");

    // Basic validation
    if (email.text.isEmpty || password.text.isEmpty) {
      print("Validation failed");
      showsuccessdialog(context, 'Error', 'Please fill in all fields', null);
      return;
    }

    Admin admin = Admin(
      email: email.text,
      password: password.text,
    );

    String requestBody = admin.toJson();
    print("Request body: $requestBody");

    try {
      var response = await DioClient().GetInstance().post('/auth', data: requestBody);
      print("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        await _saveUserData(
          response.data['access_token'], 
          response.data['admin']['name'],
          response.data['admin']['id'] 
        );
        showsuccessdialog(context, 'Success', 'Welcome back, ${response.data['admin']['name']} !', () {
          print("Navigating to home");
          Future.delayed(const Duration(seconds: 2), () {
            Get.offNamed('/home'); 
          });
        });
      } else {
        showsuccessdialog(Get.context!, 'Error', 'Incorrect email or password', null);
      }
    } catch (e) {
      showsuccessdialog(Get.context!, 'Error', 'An error occurred', null);
    }
  }

  Future<void> _saveUserData(String token, String name, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email.text);
    await prefs.setString('name', name); 
    await prefs.setInt('id', id);
  }
}
