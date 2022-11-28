part of 'version_controll_cubit.dart';

enum VersionControllStatus { initial, loading, checking, success, failure }

class VersionControllState extends Equatable {
  const VersionControllState({
    this.status = VersionControllStatus.initial,
    this.installedTables = const <String, int>{},
    this.availableTables = const <String, int>{},
    this.updateControll = const UpdateControllState(),
  });

  final VersionControllStatus status;
  final Map<String, int> availableTables;
  final Map<String, int> installedTables;
  final UpdateControllState updateControll;

  VersionControllState copyWith({
    VersionControllStatus? status,
    Map<String, int>? installedTables,
    Map<String, int>? availableTables,
    UpdateControllState? updateControll,
  }) {
    return VersionControllState(
      status: status ?? this.status,
      installedTables: installedTables ?? this.installedTables,
      availableTables: availableTables ?? this.availableTables,
      updateControll: updateControll ?? this.updateControll,
    );
  }

  @override
  List<Object?> get props => [status, availableTables, installedTables, updateControll];

  bool isInitial() {return status == VersionControllStatus.initial;}
  bool isLoading() {return status == VersionControllStatus.loading;}
  bool isChecking() {return status == VersionControllStatus.checking;}
  bool isSuccess() {return status == VersionControllStatus.success;}
  bool isFailure() {return status == VersionControllStatus.failure;}

  bool canTableUpdate(String table) {
    if (availableTables[table] == null) return false;
    if (installedTables[table] == null) return true;
    if (installedTables[table]! < availableTables[table]!) return true;
    return false;
  }

  Map<String, int> newVersion(String table, int version) {
    Map<String, int> newInstalledTables = <String, int>{};
    newInstalledTables.addAll(installedTables);
    newInstalledTables[table] = version;
    return newInstalledTables;
  }

  bool isTableInstalled(String table) {
    return (installedTables[table] != null && installedTables[table]! > 0);
  }

  bool isTableNecessary(String table) {
    if (mainTables.contains(table)) return false;
    for (var mainTable in mainTables) {
      if (!isTableInstalled(mainTable)) continue;
      if (normalizedTables[mainTable] == null) continue;
      if (normalizedTables[mainTable]!.contains(table)) return true;
    }
    return false;
  }
}

enum UpdateControllStatus {idle, updating, failure }

class UpdateControllState extends Equatable {
  const UpdateControllState({
    this.status = UpdateControllStatus.idle,
    this.inlineToUpdateTable = const <String, int>{},
    this.currentTable = "",
    this.currentUpdateProgress = 0,
    this.currentUpdateAmount = 0,
    this.overallUpdateAmount = 0,
    this.overallUpdateProgress = 0,
  });

  final UpdateControllStatus status;
  final Map<String, int> inlineToUpdateTable;
  final String currentTable;
  final int currentUpdateProgress;
  final int currentUpdateAmount;
  final int overallUpdateAmount;
  final int overallUpdateProgress;

  UpdateControllState copyWith({
    UpdateControllStatus? status,
    Map<String, int>? inlineToUpdateTable,
    String? currentTable,
    int? currentUpdateAmount,
    int? currentUpdateProgress,
    int? overallUpdateAmount,
    int? overallUpdateProgress,
  }) {
    return UpdateControllState(
      status: status ?? this.status,
      inlineToUpdateTable: inlineToUpdateTable ?? this.inlineToUpdateTable,
      currentTable: currentTable ?? this.currentTable,
      currentUpdateAmount: currentUpdateAmount ?? this.currentUpdateAmount,
      currentUpdateProgress: currentUpdateProgress ?? this.currentUpdateProgress,
      overallUpdateAmount: overallUpdateAmount ?? this.overallUpdateAmount,
      overallUpdateProgress: overallUpdateProgress ?? this.overallUpdateProgress,
    );
  }

  UpdateControllState startUpdating(Map<String, int> tables) {
    return copyWith(
      status: UpdateControllStatus.updating,
      inlineToUpdateTable: tables,
      currentTable: "",
      currentUpdateAmount: 0,
      currentUpdateProgress: 0,
      overallUpdateAmount: 0,
      overallUpdateProgress: 0,
    );
  }

  UpdateControllState updateOnce() {
    return copyWith(
      currentUpdateProgress: currentUpdateProgress + 1,
      overallUpdateProgress: overallUpdateProgress + 1,
    );
  }

  UpdateControllState nextTable(bool start) {
    Map<String, int> inlineToUpdateTable = this.inlineToUpdateTable;
    if (inlineToUpdateTable.isEmpty) {
      return copyWith(
        currentTable: "",
      );
    }
    String table = inlineToUpdateTable.keys.last;
    int? currentUpdateAmount = inlineToUpdateTable.remove(table);
    return copyWith(
      inlineToUpdateTable: inlineToUpdateTable,
      currentTable: table,
      currentUpdateAmount: currentUpdateAmount,
      currentUpdateProgress: 0,
      overallUpdateProgress: start ? overallUpdateProgress : overallUpdateProgress + 1,
    );
  }

  @override
  List<Object?> get props => [status, inlineToUpdateTable, currentTable];

  bool isIdle() {return status == UpdateControllStatus.idle;}
  bool isUpdating() {return status == UpdateControllStatus.updating;}
  bool isFailure() {return status == UpdateControllStatus.failure;}

  int getTableAmount() {
    int amount = 0;
    if (currentTable.isNotEmpty) amount += 1;
    amount += inlineToUpdateTable.length;
    return amount;
  }

  bool isTableUpdating(String table) {
    if (inlineToUpdateTable.containsKey(table)) return true;
    if (currentTable == table) return true;
    return false;
  }

  int getTableUpdateAmount(String table) {
    if (inlineToUpdateTable.containsKey(table)) return inlineToUpdateTable[table]!;
    if (currentTable == table) return currentUpdateAmount;
    return 0;
  }

  int getTableUpdateProgress(String table) {
    if (inlineToUpdateTable.containsKey(table)) return 0;
    if (currentTable == table) return currentUpdateProgress;
    return 0;
  }

  double getProgressValue(String? table) {
    double progressValue = 0;
    if (table == null) progressValue = overallUpdateProgress/overallUpdateAmount;
    if (currentTable == table) progressValue = currentUpdateProgress/currentUpdateAmount;
    if (inlineToUpdateTable.containsKey(table)) return 0;
    if (progressValue.isNaN) return 0;
    return progressValue;
  }
}