import 'package:airportadminflutter/controller/adminsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Admins extends StatefulWidget {
  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  static final Adminscontroller controller = Get.put(Adminscontroller());

  @override
  void initState() {
    super.initState();
    controller.viewAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Admins List'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Obx(() {
                if (controller.admins.isEmpty) {
                  return Center(child: Text("No admins found"));
                }
                return ListView.builder(
                  itemCount: controller.admins.length,
                  itemBuilder: (context, index) {
                    final admin = controller.admins[index];
                    return ListTile(
                      title: Text(admin.name),
                      subtitle: Text(admin.email),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
