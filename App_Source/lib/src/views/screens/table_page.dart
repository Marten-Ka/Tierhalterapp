import 'package:agile_prototyp/src/bloc/data_accessor_cubit.dart';
import 'package:agile_prototyp/src/constants/tables.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablePage extends StatefulWidget {
  const TablePage({Key? key, required this.table}) : super(key: key);
  final String table;

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  bool isLoaded = false;
  late List<DataRow> row;

  void setValue(List<DataRow> value) {
    row = value;
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> column = tableColumns[widget.table]!.map((item) => DataColumn(label: Text(item))).toList();
    BlocProvider.of<DataAccessorCubit>(context, listen: false).state.getTableItems(widget.table).then((value) => setValue(value));
    if (!isLoaded) {
      return const Text("Loading");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.table, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
            columnSpacing: 10,
            horizontalMargin: 10,
            minWidth: column.length * 200,
            columns: column,
            rows: row,
        ),
      ),
    );
  }
}
