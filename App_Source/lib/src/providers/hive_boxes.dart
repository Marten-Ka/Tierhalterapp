import 'package:agile_prototyp/src/constants/tables.dart';
import 'package:agile_prototyp/src/models/krankheiten.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  HiveBoxes._() {}

  static final instance = HiveBoxes._();
  Set<String> openBoxes = <String>{};

  Future<Box<int>> openVersion() async {
    if (openBoxes.contains("Versions")) return Hive.box<int>("Versions");
    openBoxes.add("Versions");
    return await Hive.openBox<int>("Versions");
  }

  Future<LazyBox> openMainTable(String table) async {
    if (openBoxes.contains(table)) return Hive.lazyBox<Krankheiten>(table);
    openBoxes.add(table);
    return await Hive.openLazyBox<Krankheiten>(table);
  }

  Future<Box<String>> openNormalizedTable(String table) async {
    if (openBoxes.contains(table)) return Hive.box<String>(table);
    openBoxes.add(table);
    return await Hive.openBox<String>(table);
  }

  bool isTableOpen(String table) {
    return openBoxes.contains(table);
  }

  Future<Box<int>> deleteBox(String table) async {
    openBoxes.remove(table);
    Box<int> versionBox = Hive.box<int>("Versions");
    await versionBox.delete(table);
    if (mainTables.contains(table)) {
      LazyBox mainBox = await openMainTable(table);
      mainBox.clear();
      return versionBox;
    }
    Box normalizedBox = await openNormalizedTable(table);
    normalizedBox.clear();
    return versionBox;
  }
}

