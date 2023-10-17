import 'package:flutter/material.dart';

showSnackBar(
    {required BuildContext context,
    required String mensage,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
      content: Text(mensage),
      backgroundColor: (isError) ? Colors.red : Colors.black54);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
