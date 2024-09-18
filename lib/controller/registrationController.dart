import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:airportadminflutter/model/Admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void register(BuildContext context) async {
    print("Register method called");

    // Basic validation
    if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
      print("Validation failed");
      showsuccessdialog(context, 'Error', 'Please fill in all fields', null);
      return;
    }

    Admin admin = Admin(
      name: name.text,
      email: email.text,
      password: password.text,
    );

    String request_body = admin.toJson();
    print("Request body: $request_body");

    try {
      var response = await DioClient().GetInstance().put('/auth', data: request_body);
      print("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        await _saveUserData(response.data['access_token']);
        showsuccessdialog(context, 'Success', 'Registration successful!', () {
          print("Navigating to home");
          Future.delayed(const Duration(seconds: 5));
          print(_saveUserData);
          Get.offNamed('/home');
        });
      } else {
        showsuccessdialog(context, 'Error', 'Registration failed. Please try again.', null);
      }
    } catch (e) {
      showsuccessdialog(context, 'Error', 'An error occurred: $e', null);
    }
  }

  Future<void> _saveUserData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('name', name.text);
    await prefs.setString('email', email.text);
    await prefs.setString('password', password.text);
  }
}
