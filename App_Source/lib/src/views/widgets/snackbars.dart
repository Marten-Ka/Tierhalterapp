import 'package:flutter/material.dart';

void createSuccessSnackbar(BuildContext context, String successMsg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(successMsg),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Schließen',
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      )));
}
