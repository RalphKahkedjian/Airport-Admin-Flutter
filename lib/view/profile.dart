import 'package:airportadminflutter/controller/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
   static final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Padding(padding: const EdgeInsets.all(40),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                  controller: TextEditingController(text: userData['password']),
                ),
                SizedBox(height: 20,),
                Center(
                  child: ElevatedButton(onPressed: (){
                    controller.logout();
                  }, 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange[900])),
                  child: Text("Logout", style: TextStyle(color: Colors.white),))
                )
              ],
            ),)
          );
        },
      ),
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');

    return {
      'name': name,
      'email': email,
    };
  }
}
