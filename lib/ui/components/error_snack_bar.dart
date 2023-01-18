import 'package:flutter/material.dart';

class ErrorSnackBar {
  static show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[900],
        content: Text(message),
      ),
    );
  }
}
