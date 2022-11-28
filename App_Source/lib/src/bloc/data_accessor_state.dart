part of 'data_accessor_cubit.dart';

enum DataAccessorStatus { initial, loading, success, failure }

class DataAccessorState extends Equatable {
  const DataAccessorState({
    this.status = DataAccessorStatus.initial,
    this.mainTable = "",
    this.mainTableBox,
    this.tableKeys = const <int>[],
    this.normalizedTables = const <String, Map<int, String>>{},
  });

  final DataAccessorStatus status;
  final String mainTable;
  final LazyBox? mainTableBox;
  final List<int> tableKeys;
  final Map<String, Map<int, String>> normalizedTables;

  DataAccessorState copyWith({
    DataAccessorStatus? status,
    String? mainTable,
    LazyBox? mainTableBox,
    List<int>? tableKeys,
    Map<String, Map<int, String>>? normalizedTables,
  }) {
    return DataAccessorState(
      status: status ?? this.status,
      mainTable: mainTable ?? this.mainTable,
      mainTableBox: mainTableBox ?? this.mainTableBox,
      tableKeys: tableKeys ?? this.tableKeys,
      normalizedTables: normalizedTables ?? this.normalizedTables,
    );
  }

  DataAccessorState startLoading() {
    return const DataAccessorState(
      status: DataAccessorStatus.loading,
      mainTable: "",
      mainTableBox: null,
      tableKeys: <int>[],
      normalizedTables: <String, Map<int, String>>{},
    );
  }

  @override
  List<Object?> get props => [status, mainTable, mainTableBox, tableKeys, normalizedTables];

  bool isInitial() {return status == DataAccessorStatus.initial;}
  bool isLoading() {return status == DataAccessorStatus.loading;}
  bool isSuccess() {return status == DataAccessorStatus.success;}
  bool isFailure() {return status == DataAccessorStatus.failure;}

  int getTableAmount(String table) {
    if (table == mainTable) return tableKeys.length;
    if (normalizedTables.containsKey(table)) return normalizedTables[table]!.length;
    return 0;
  }

  Future<List<DataRow>> getTableItems(String table) async {
    if (table == mainTable) {
      List<DataRow> list = <DataRow>[];
      for (var keys in tableKeys) {
        Krankheiten item = await mainTableBox!.get(keys);
        list.add(item.toDataRow(normalizedTables));
      }
      return list;
    }
    if (normalizedTables.containsKey(table)) {
      List<DataRow> list = <DataRow>[];
      if (normalizedTables[table] == null) return <DataRow>[];
      normalizedTables[table]?.forEach((key, value) {
        list.add(DataRow(cells: [
          DataCell(Text(key.toString())),
          DataCell(Text(value.toString())),
        ]));
      });
      return list;
    }
    return <DataRow>[];
  }
}
