import 'package:airportadminflutter/controller/adminsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Admins extends StatelessWidget {
  final Adminscontroller controller = Get.put(Adminscontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admins and Users'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.viewAdmins();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                child: Text(
                  'Admins',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  controller.viewUsers();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                child: Text(
                  'Users',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (controller.admins.isEmpty) {
                return Center(
                  child: Text('No data available'),
                );
              }
              return ListView.builder(
                itemCount: controller.admins.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 4.0,
                        child: ListTile(
                          title: Center(
                            child: Text(
                              controller.admins[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(controller.admins[index].email),
                          ),
                          trailing: controller.activeTab.value == 'users'
                              ? IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm Delete"),
                                          content: Text("Are you sure you want to delete this user?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Delete"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                controller.deleteUser(controller.admins[index].id);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
