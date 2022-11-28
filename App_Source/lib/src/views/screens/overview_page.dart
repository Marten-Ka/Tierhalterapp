import 'dart:async';

import 'package:agile_prototyp/src/bloc/data_accessor_cubit.dart';
import 'package:agile_prototyp/src/bloc/version_controll_cubit.dart';
import 'package:agile_prototyp/src/constants/tables.dart';
import 'package:agile_prototyp/src/views/widgets/sub_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult connectStatus = ConnectivityResult.none;
  String selectedValue = informationPageName;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    BlocProvider.of<VersionControllCubit>(context).startCheck(context);
    BlocProvider.of<DataAccessorCubit>(context).loadDatabase(krankheiten);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vc = BlocProvider.of<VersionControllCubit>(context, listen: true).state;
    return Scaffold(
      appBar: _getAppBar(vc),
      body: _getBody(vc),
    );
  }

  AppBar _getAppBar(VersionControllState vc) {
    List<String> list = _getAppBarList(vc);
    if (!list.contains(selectedValue)) list.add(selectedValue);
    return AppBar(
      backgroundColor: Colors.white70,
      title: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          items: list
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(tableNames[item] ?? item),
                  )).toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
        ),
      ),
    );
  }

  List<String> _getAppBarList(VersionControllState vc) {
    var list = [informationPageName, versionsPageName];
    for (var mainTable in mainTables) {
      list.add(mainTable);
      if (normalizedTables.containsKey(mainTable)) {
        normalizedTables[mainTable]?.forEach((subTable) {
          if (vc.installedTables.containsKey(subTable)) list.add(subTable);
        });
      }
    }
    return list;
  }

  Widget _getBody(VersionControllState vc) {
    if (selectedValue == versionsPageName) return versionsPage(context, vc, connectStatus);
    if (mainTables.contains(selectedValue) || tableNames.containsKey(selectedValue)) return tableOverviewPage(context, vc, selectedValue, connectStatus);
    return informationPage(connectStatus);
  }
}
