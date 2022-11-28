import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../bloc/version_controll_cubit.dart';

void createInstallDialog(BuildContext context, String msg, bool isUpdate) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: isUpdate ? "Möchtest du\n" + msg + "\naktualisieren?" : "Möchtest du\n" + msg + "\ninstallieren?",
    buttons: [
      DialogButton(
        child: const Text(
          "Ja",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => {
          BlocProvider.of<VersionControllCubit>(context, listen: false).fetchTable(context, msg.split(",\n"), false),
          Navigator.pop(context),
        },
        color: Colors.lightGreen,
      ),
      DialogButton(
        child: const Text(
          "Nein",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.redAccent,
      )
    ],
  ).show();
}
