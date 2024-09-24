import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:get/get.dart';

class Admin {
  final String name;
  final String email;
  final int id;

  Admin({required this.id, required this.name, required this.email});
}

class Adminscontroller extends GetxController {
  var admins = <Admin>[].obs;
  var activeTab = 'admins'.obs;

  void viewAdmins() async {
    activeTab.value = 'admins';
    try {
      var response = await DioClient().GetInstance().get('/admin');
      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['data'] is List) {
          var data = response.data['data'] as List;
          admins.value = data
              .map((admin) => Admin(
                  id: admin['id'],
                  name: admin['name'],
                  email: admin['email']))
              .toList();
        } else {
          print('Error: "data" key is missing or not a list.');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  void viewUsers() async {
    activeTab.value = 'users';
    try {
      var response = await DioClient().GetInstance().get('/user');
      if (response.statusCode == 200) {
        if (response.data['data'] is List) {
          var data = response.data['data'] as List;
          admins.value = data
              .map((user) => Admin(
                  id: user['id'], 
                  name: user['name'],
                  email: user['email']))
              .toList();
        } else {
          print('Error: "data" key is missing or not a list.');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  void deleteUser(int userId) async {
    try {
      var response = await DioClient().GetInstance().delete('/user/$userId');
      if (response.statusCode == 200) { // Check for successful deletion
        showsuccessdialog(Get.context!, "User deleted successfully", "", null);
        viewUsers();
      } else {
        print('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      print("Failed to delete user: $e");
    }
  }
}
