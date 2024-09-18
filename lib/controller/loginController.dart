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
          response.data['admin']['name'], // Correctly retrieve the name
          response.data['admin']['id'] // Correctly retrieve the ID
        );
        showsuccessdialog(context, 'Success', 'Login successful!', () {
          print("Navigating to home");
          Future.delayed(const Duration(seconds: 2), () {
            Get.offNamed('/home'); // Navigate to home screen
          });
        });
      } else {
        showsuccessdialog(context, 'Error', 'Login failed. Please try again.', null);
      }
    } catch (e) {
      showsuccessdialog(context, 'Error', 'An error occurred: $e', null);
    }
  }

  Future<void> _saveUserData(String token, String name, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email.text);
    await prefs.setString('name', name); // Save the user's name correctly
    await prefs.setInt('id', id); // Save the user's ID correctly as an integer
  }
}
