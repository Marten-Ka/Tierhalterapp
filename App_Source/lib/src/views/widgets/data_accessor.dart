import 'package:agile_prototyp/src/bloc/data_accessor_cubit.dart';
import 'package:agile_prototyp/src/views/screens/table_page.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Widget getTableInfo(BuildContext context, DataAccessorState da, String table) {
  if (da.status == DataAccessorStatus.loading) {
    return Card(
      color: Colors.white70,
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(table),
        subtitle: const Text("Loading..."),
        leading: const Icon(Icons.table_chart, size: 35),
      ),
    );
  }
  if (da.status == DataAccessorStatus.failure) {
    return Card(
      color: Colors.white70,
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(table),
        subtitle: const Text("Laden der Datenbank fehlerhaft"),
        leading: const Icon(Icons.table_chart, size: 35),
      ),
    );
  }
  int itemAmount = da.getTableAmount(table);
  if (itemAmount == 0) {
    return Card(
      color: Colors.white70,
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
            title: Text(table),
            subtitle: const Text("Keine Einträge gefunden"),
          leading: const Icon(Icons.table_chart, size: 35),
        ),
    );
  }
  return Card(
    color: Colors.white70,
    elevation: 3.0,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      closedColor: Colors.white70,
      closedElevation: 0.0,
      openElevation: 4.0,
      transitionDuration: const Duration(milliseconds: 1500),
      openBuilder: (BuildContext context, VoidCallback _) => TablePage(
        table: table,
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return ListTile(
          title: Text(table),
          subtitle: Text(itemAmount.toString()+" Einträge gefunden"),
          leading: const Icon(Icons.table_chart, size: 35),
        );
      },
    ),
  );
}
