import 'package:agile_prototyp/src/bloc/data_accessor_cubit.dart';
import 'package:agile_prototyp/src/bloc/version_controll_cubit.dart';
import 'package:agile_prototyp/src/views/widgets/connection_indicator.dart';
import 'package:agile_prototyp/src/views/widgets/data_accessor.dart';
import 'package:agile_prototyp/src/views/widgets/version_controll.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const informationPageName = "Informationen";
Widget informationPage(ConnectivityResult result) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      getInternetConnection(result),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.arrow_upward, size: 70),
          Text("Appbar beinhaltet \n Dropdown-Liste", style: TextStyle(fontSize: 12)),
        ],
      ),
      const Text("Wechsel zwischen den verschiedenen Seiten \n für das Verwenden des Prototypen",
          style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
      const Spacer(flex: 1),
      const Text("„Entwicklung einer geeigneten Möglichkeit zur \n Gesundheitsdatenhaltung im mobilen \n Anwendungsbereich“",
          style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
      const Spacer(flex: 2),
      //Text(
      // "Prototyp erstellt von ...",
      // textAlign: TextAlign.center
      // ),
    ],
  );
}

const versionsPageName = "Versions-Kontrolle";
Widget versionsPage(BuildContext context, VersionControllState vc, ConnectivityResult result) {
  var list = <Widget>[];
  list.add(getInternetConnection(result));
  list.add(getVersionControllOverview(context, vc));
  list.add(const Divider(thickness: 5, height: 10));
  if (vc.updateControll.isUpdating()) {
    list.add(getVersionUpdateOverview(context, vc.updateControll));
    list.add(const Divider(thickness: 5, height: 10));
  }
  if (vc.updateControll.isFailure()) {
    list.add(getFailureUpdateOverview(context, vc.updateControll));
    list.add(const Divider(thickness: 5, height: 10));
  }
  list.addAll(getVersionListOfAllTables(context, vc));
  return SingleChildScrollView(
    child: Column(children: list),
  );
}

Widget tableOverviewPage(BuildContext context, VersionControllState vc, String table, ConnectivityResult result) {
  var da = BlocProvider.of<DataAccessorCubit>(context, listen: true).state;
  if (!vc.installedTables.containsKey(table)) {
    return Column(children: [
      getInternetConnection(result),
      const Spacer(),
      getTableVersion(context, vc, table),
      const Spacer(),
    ]);
  }
  return SingleChildScrollView(
    child: Column(children: [
      getInternetConnection(result),
      getTableVersion(context, vc, table),
      const Divider(thickness: 5, height: 10),
      getTableInfo(context, da, table),
      const Divider(thickness: 5, height: 10),
    ]),
  );
}