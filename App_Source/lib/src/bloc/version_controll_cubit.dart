import 'dart:convert';
import 'package:agile_prototyp/src/constants/github.dart';
import 'package:agile_prototyp/src/constants/tables.dart';
import 'package:agile_prototyp/src/models/api_item.dart';
import 'package:agile_prototyp/src/models/normalized.dart';
import 'package:agile_prototyp/src/providers/hive_boxes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/krankheiten.dart';
import '../views/widgets/dialogs.dart';
import '../views/widgets/snackbars.dart';
import 'data_accessor_cubit.dart';

part 'version_controll_state.dart';

class VersionControllCubit extends Cubit<VersionControllState> {
  VersionControllCubit() : super(const VersionControllState());

  Future<void> startCheck(BuildContext context) async {
    bool canUpdate = false;
    List<String> tables = [];
    await checkForUpdates();
    state.installedTables.forEach((key, value) {
      if (state.availableTables[key] != null) {
        if (state.availableTables[key]! > value) {
          tables.add(key);
          canUpdate = true;
        }
      }

    });
    if (canUpdate) {
      createInstallDialog(context, tables.join(",\n"), true);
    }
  }

  Future<void> checkForUpdates() async {
    emit(state.copyWith(status: VersionControllStatus.loading));
    await _loadVersions();
    await _loadRemoteVersions();
  }

  Future<void> _loadVersions() async {
    Box<int> versionBox = await HiveBoxes.instance.openVersion();
    emit(state.copyWith(installedTables: versionBox.toMap().cast<String, int>()));
  }

  Future<void> _loadRemoteVersions() async {
    Map<String, int> remoteVersions = <String, int>{};
    http.Response response = await http.get(Uri.parse(versionFile));
    if (response.statusCode == 200) {
      remoteVersions = Map<String, int>.from(json.decode(response.body));
      emit(state.copyWith(status: VersionControllStatus.success, availableTables: remoteVersions));
      return;
    } else {
      emit(state.copyWith(updateControll: state.updateControll.copyWith(status: UpdateControllStatus.failure)));
      return;
    }
  }

  Future<void> fetchTable(BuildContext context, List<String> tableList, bool ask) async {
    if (state.updateControll.isUpdating()) return;
    List<String> updatingTables;
    if (tableList.length == 1) {
      updatingTables = getUpdatingTablesList(tableList[0]);
    } else {
      updatingTables = tableList;
    }
    Map<String, int> tables = <String, int>{};
    for (var element in updatingTables) {
      tables[element] = 0;
    }

    if (ask) {
      createInstallDialog(context, updatingTables.join(",\n"), false);
      return;
    }

    emit(state.copyWith(updateControll: state.updateControll.startUpdating(tables)));

    List<ApiItem> remoteFolders = await getRemoteFolder(updatingTables);
    if (remoteFolders.isEmpty) {
      emit(state.copyWith(updateControll: state.updateControll.copyWith(status: UpdateControllStatus.failure)));
      return;
    }

    Map<String, List<ApiItem>> newerTableVersions = await getNewerTableVersions(remoteFolders);
    if (newerTableVersions.isEmpty) {
      emit(state.copyWith(updateControll: state.updateControll.copyWith(status: UpdateControllStatus.failure)));
      return;
    }

    Map<String, int> updatedInlineToUpdate = <String, int>{};
    int overallAmount = 0;
    newerTableVersions.forEach((key, value) {
      updatedInlineToUpdate[key] = value.length;
      overallAmount += value.length;
    });
    emit(state.copyWith(updateControll: state.updateControll.copyWith(inlineToUpdateTable: updatedInlineToUpdate, overallUpdateAmount: overallAmount)));
    emit(state.copyWith(updateControll: state.updateControll.nextTable()));

    await processUpdateLoop(context, newerTableVersions);

    BlocProvider.of<DataAccessorCubit>(context).reload();
    emit(state.copyWith(updateControll: state.updateControll.copyWith(status: UpdateControllStatus.idle)));
  }

  List<String> getUpdatingTablesList(String table) {
    List<String> updatingTables = [table];
    if (normalizedTables.containsKey(table)) {
      normalizedTables[table]?.forEach((element) {
        if(state.canTableUpdate(element)) {
          updatingTables.add(element);
        }
      });
    }
    return updatingTables;
  }

  Future<List<ApiItem>> getRemoteFolder(List<String> updatingTables ) async {
    List<ApiItem> remoteFolders = <ApiItem>[];
    http.Response? response = await http.get(Uri.parse(githubApiBase));
    if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    remoteFolders = (responseJson['tree'] as List).map((p) => ApiItem.fromJson(p)).toList();
    remoteFolders.removeWhere((element) => !updatingTables.contains(element.path));
    }
    return remoteFolders;
  }
  Future<Map<String, List<ApiItem>>> getNewerTableVersions(List<ApiItem> remoteFolders) async {
    Map<String, List<ApiItem>> newerTableVersions = <String, List<ApiItem>>{};
    List<ApiItem> temp = <ApiItem>[];
    for (var table in remoteFolders) {
      newerTableVersions[table.path] = <ApiItem>[];
      http.Response? response = await http.get(Uri.parse(table.url));
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        temp = (responseJson['tree'] as List).map((p) => ApiItem.fromJson(p)).toList();
        temp.asMap().forEach((key, tableVersion) {
          newerTableVersions[table.path]!.add(tableVersion.copyWith(path: tableVersion.path.substring(0, tableVersion.path.length - 5)));
        });
        newerTableVersions[table.path]!.sort((a, b) => a.path.compareTo(b.path));
      } else {
        emit(state.copyWith(updateControll: state.updateControll.copyWith(status: UpdateControllStatus.failure)));
        return {};
      }
    }
    newerTableVersions.removeWhere((key, value) => value.isEmpty);
    return newerTableVersions;
  }

  Future<void> processUpdateLoop(BuildContext context, Map<String, List<ApiItem>> newerTableVersions) async {
    http.Response? response;
    String path = "";
    String table = "";
    Box<int> versionBox = await HiveBoxes.instance.openVersion();
    while(state.updateControll.currentTable.isNotEmpty) {
      table = state.updateControll.currentTable;
      while(newerTableVersions[table]!.isNotEmpty) {
        ApiItem item = newerTableVersions[table]!.removeLast();
        path = githubRawBase+"/"+table+"/"+item.path+".json";
        response = await http.get(Uri.parse(path));
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body);
          response = null;
          switch(table) {
            case krankheiten:
              List<Krankheiten> krankheitenList = (responseJson as List).map((p) => Krankheiten.fromJson(p)).toList();
              responseJson = "";
              LazyBox krankheitenBox = await HiveBoxes.instance.openMainTable(table);
              while(krankheitenList.isNotEmpty) {
                Krankheiten krankheitenItem = krankheitenList.removeLast();
                await krankheitenBox.put(krankheitenItem.id, krankheitenItem);
              }
              krankheitenBox.flush();
              break;
            default:
              List<Normalized> normalizedList = (responseJson as List).map((p) => Normalized.fromJson(p)).toList();
              responseJson = "";
              Box<String> normalizedBox = await HiveBoxes.instance.openNormalizedTable(table);
              while(normalizedList.isNotEmpty) {
                Normalized normalizedItem = normalizedList.removeLast();
                await normalizedBox.put(normalizedItem.id, normalizedItem.name);
              }
              normalizedBox.flush();
              break;
          }
          int newVersion = int.parse(item.path);
          versionBox.put(table, newVersion);
          emit(state.copyWith(updateControll: state.updateControll.updateOnce(), installedTables: state.newVersion(table, newVersion)));
        } else {
          emit(state.copyWith(updateControll: state.updateControll.copyWith(status: UpdateControllStatus.failure)));
          return;
        }
      }
      createSuccessSnackbar(context, table+" installiert");
      emit(state.copyWith(updateControll: state.updateControll.nextTable()));
    }
  }

  Future<void> delete(String table) async {
    Box<int> versionBox = await HiveBoxes.instance.deleteBox(table);
    emit(state.copyWith(installedTables: versionBox.toMap().cast<String, int>()));
  }
}
