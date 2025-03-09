import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension StateExtention on State {
  showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
