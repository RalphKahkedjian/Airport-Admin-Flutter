import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showsuccessdialog(BuildContext context, String title, String body, Function? callback) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title, style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.w700),),
        content: Text(body, style: TextStyle(color: Colors.orange[900]),),
        actions: [
          Center(
            child: TextButton(
            child: Text("OK", style: TextStyle(color: Colors.orange[900]),),
            onPressed: () {
              Navigator.of(context).pop();
              if (callback != null) {
                callback();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
            ),
          ),
          )
        ],
      );
    },
  );
}
