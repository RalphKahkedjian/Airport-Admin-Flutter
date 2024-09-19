import 'package:airportadminflutter/controller/homeController.dart';
import 'package:airportadminflutter/core/showSuccessDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  static final HomeController controller = Get.put(HomeController());
  String password = "1234567"; // Created a random password text 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Your Profile'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        ),
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data!;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Admin ID',
                    ),
                    controller: TextEditingController(text: userData['id']),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    controller: TextEditingController(text: userData['name']),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    controller: TextEditingController(text: userData['email']),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    controller: TextEditingController(text: password),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      children: <Widget>[
                       ElevatedButton(
                        onPressed: () {
                          controller.logout();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.orange[900]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0), // Set border radius to 0
                            ),
                          ),
                        ),
                        child: Text("Logout", style: TextStyle(color: Colors.white)),
                      ),

                      SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: () async {
                          // Get admin ID from SharedPreferences
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          int? adminId = prefs.getInt('id'); // Make sure to store the ID as an int during registration

                          if (adminId != null) {
                            controller.deleteAccount(adminId);
                          } else {
                            showsuccessdialog(Get.context!, "Error", "Admin ID not found.", () {});
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.orange[900]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0), // Set border radius to 0
                            ),
                          ),
                        ),
                        child: Text("Delete", style: TextStyle(color: Colors.white)),
                      ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    int? id = prefs.getInt('id'); // Retrieve the admin ID as int

    return {
      'name': name,
      'email': email,
      'id': id?.toString(), // Convert the ID to a string for display
    };
  }
}
