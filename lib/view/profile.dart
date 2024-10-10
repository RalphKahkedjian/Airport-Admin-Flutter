import 'package:airportadminflutter/controller/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  static final HomeController controller = Get.put(HomeController());
  String password = "1234567"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Center(child: Text('Your Profile'),),
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                          backgroundColor: MaterialStateProperty.all(Colors.blueGrey[900]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        child: Text("Logout", style: TextStyle(color: Colors.white)),
                      ),

                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          int? adminId = prefs.getInt('id');
                          if (adminId != null) {
                            controller.deleteAccount(adminId);
                          } 
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blueGrey[900]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
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
    int? id = prefs.getInt('id'); 
    return {
      'name': name,
      'email': email,
      'id': id?.toString(),
    };
  }
}
