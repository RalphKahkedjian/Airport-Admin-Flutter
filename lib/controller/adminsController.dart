import 'package:airportadminflutter/core/network/dioClient.dart';
import 'package:get/get.dart';

class Admin {
  final String name;
  final String email;

  Admin({required this.name, required this.email});
}

class Adminscontroller extends GetxController {
  var admins = <Admin>[].obs;

void viewAdmins() async {
  try {
    var response = await DioClient().GetInstance().get('/admin');
    print('Response: ${response.data}');

    if (response.statusCode == 200) {
      if (response.data['data'] is List) {
        var data = response.data['data'] as List;
        admins.value = data
            .map((admin) => Admin(name: admin['name'], email: admin['email']))
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
}
