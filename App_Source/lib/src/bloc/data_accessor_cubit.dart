import 'package:agile_prototyp/src/constants/tables.dart';
import 'package:agile_prototyp/src/providers/hive_boxes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/krankheiten.dart';

part 'data_accessor_state.dart';

class DataAccessorCubit extends Cubit<DataAccessorState> {
  DataAccessorCubit() : super(const DataAccessorState());

  Future<void> loadDatabase(String table) async {
    emit(state.startLoading());
    LazyBox mainBox = await HiveBoxes.instance.openMainTable(table);
    List<int> tableKeys = mainBox.keys.toList().cast<int>();
    Map<String, Map<int, String>> normalizedTablesContent = <String, Map<int, String>>{};
    for (var normaltable in normalizedTables[table]!) {
      Box tableBox = await HiveBoxes.instance.openNormalizedTable(normaltable);
      normalizedTablesContent[normaltable] = <int, String>{};
      Map<int, String> content = tableBox.toMap().cast<int, String>();
      if (content.isNotEmpty) normalizedTablesContent[normaltable]!.addAll(content);
    }
    emit(state.copyWith(status: DataAccessorStatus.success, mainTable: table, tableKeys: tableKeys, mainTableBox: mainBox, normalizedTables: normalizedTablesContent));
  }

  Future<void> reload() async {
    loadDatabase(state.mainTable);
  }
}

