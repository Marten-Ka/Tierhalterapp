import 'package:agile_prototyp/src/bloc/version_controll_cubit.dart';
import 'package:agile_prototyp/src/constants/tables.dart';
import 'package:agile_prototyp/src/providers/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget getTableVersion(BuildContext context, VersionControllState vc, String table) {
  switch (vc.status) {
    case VersionControllStatus.initial:
    case VersionControllStatus.loading:
    case VersionControllStatus.checking:
      return _getVersionLoading();
    case VersionControllStatus.success:
      return _getVersionCard(context, vc, table);
    case VersionControllStatus.failure:
      return _getVersionFailure();
  }
}

Widget _getVersionLoading() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      CircularProgressIndicator(
        color: Colors.lightGreen,
        backgroundColor: Colors.white,
      ),
      SizedBox(height: 15),
      Text("Loading....", style: TextStyle(fontSize: 20, color: Colors.lightGreen, fontWeight: FontWeight.w500))
    ],
  );
}

Widget _getVersionFailure() {
  return const Text("Es ist ein Fehler aufgetreten");
}

Widget getVersionControllOverview(BuildContext context, VersionControllState vc) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tabellen definiert: " + tableNames.length.toString()),
            Text("Tabellen installiert: " + vc.installedTables.length.toString()),
            Text("Tabellen installierbar: " + vc.availableTables.length.toString()),
          ],
        ),
        const Spacer(),
        getVersionControllUpdateButton(context, vc),
      ],
    ),
  );
}

Widget getVersionControllUpdateButton(BuildContext context, VersionControllState vc) {
  if (vc.status == VersionControllStatus.loading || vc.status == VersionControllStatus.checking) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Check for Updates'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
        backgroundColor: MaterialStateProperty.all(Colors.black38),
      ),
    );
  }
  return ElevatedButton(
    onPressed: () {
      BlocProvider.of<VersionControllCubit>(context, listen: false).checkForUpdates();
    },
    child: const Text('Check for Updates'),
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
      backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
    ),
  );
}

Widget getVersionUpdateOverview(BuildContext context, UpdateControllState uc) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Derzeit am Updaten: " + uc.currentTable),
        Text("Anzahl zu Updaten: " + uc.getTableAmount().toString()),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                minHeight: 10,
                value: uc.getProgressValue(null),
                color: Colors.lightGreen,
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(width: 15),
            Text(uc.overallUpdateProgress.toString() + " / " + uc.overallUpdateAmount.toString()),
          ],
        ),
      ],
    ),
  );
}

Widget getFailureUpdateOverview(BuildContext context, UpdateControllState uc) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    transformAlignment: Alignment.center,
    child: Column(
      children: [
        const Text("Es ist ein Fehler aufgetreten!", style: TextStyle(color: Colors.red, fontSize: 16)),
        const Text("Limit der Github-API für die IP überschritten. \n Bitte versuchen Sie es später nochmal."),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
            backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.9)),
          ),
          child: const Text("Retry", style: TextStyle(color: Colors.black, decoration: TextDecoration.underline)),
          onPressed: () {},
        ),
      ],
    ),
  );
}

List<Widget> getVersionListOfAllTables(BuildContext context, VersionControllState vc) {
  switch (vc.status) {
    case VersionControllStatus.initial:
    case VersionControllStatus.loading:
    case VersionControllStatus.checking:
      return [const SizedBox(height: 150), _getVersionLoading()];
    case VersionControllStatus.success:
      break;
    case VersionControllStatus.failure:
      return [const SizedBox(height: 150), _getVersionFailure()];
  }
  var list = <Widget>[];
  tableNames.forEach((key, value) {
    list.add(_getVersionCard(context, vc, key));
    list.add(const Divider(thickness: 5, height: 10));
  });
  return list;
}

Widget _getVersionCard(BuildContext context, VersionControllState vc, String table) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(tableNames[table] ?? table, style: const TextStyle(fontSize: 20)),
        Container(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vc.installedTables.containsKey(table) ? "Lokal: " + timeStampToDateString(vc.installedTables[table]!) : "Nicht Installiert"),
                Container(height: 10.0),
                Text(vc.availableTables.containsKey(table) ? "Remote: " + timeStampToDateString(vc.availableTables[table]!) : "Unbekannte Version"),
              ],
            ),
            const Spacer(),
            _getActionButton(context, vc, table),
          ],
        ),
        const SizedBox(height: 5),
        if (vc.updateControll.isTableUpdating(table))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: vc.updateControll.getProgressValue(table),
                  color: Colors.lightGreen,
                  backgroundColor: Colors.grey,
                ),
              ),
              const SizedBox(width: 15),
              Text(vc.updateControll.getTableUpdateProgress(table).toString() + " / " + vc.updateControll.getTableUpdateAmount(table).toString()),
            ],
          ),
      ],
    ),
  );
}

Widget _getActionButton(BuildContext context, VersionControllState vc, String table) {
  int? installedVersion = vc.installedTables[table];
  int? availableVersion = vc.availableTables[table];
  if (vc.updateControll.isTableUpdating(table)) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Updating'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
        backgroundColor: MaterialStateProperty.all(Colors.black38),
        minimumSize: MaterialStateProperty.all(const Size(100, 30)),
      ),
    );
  }
  if (availableVersion == null) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text(''),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
        backgroundColor: MaterialStateProperty.all(Colors.black38),
        minimumSize: MaterialStateProperty.all(const Size(100, 30)),
      ),
    );
  }
  if (installedVersion == null) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<VersionControllCubit>(context, listen: false).fetchTable(context, [table], true);
      },
      child: const Text('Installieren'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
        backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
        minimumSize: MaterialStateProperty.all(const Size(100, 30)),
      ),
    );
  }
  if (installedVersion < availableVersion) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<VersionControllCubit>(context, listen: false).fetchTable(context, [table], true);
      },
      child: const Text('Aktualisieren'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
        backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
        minimumSize: MaterialStateProperty.all(const Size(100, 30)),
      ),
    );
  }
  if (vc.isTableNecessary(table)) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Deinstallieren'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
        backgroundColor: MaterialStateProperty.all(Colors.black38),
        minimumSize: MaterialStateProperty.all(const Size(100, 30)),
      ),
    );
  }
  if (installedVersion == availableVersion) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<VersionControllCubit>(context, listen: false).delete(table);
      },
      child: const Text('Deinstallieren'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
        backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        minimumSize: MaterialStateProperty.all(const Size(100, 30)),
      ),
    );
  }
  return ElevatedButton(
    onPressed: () {},
    child: const Text('Fehler'),
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
      backgroundColor: MaterialStateProperty.all(Colors.red),
      minimumSize: MaterialStateProperty.all(const Size(100, 30)),
    ),
  );
}
