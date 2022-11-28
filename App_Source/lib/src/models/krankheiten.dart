import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:agile_prototyp/src/constants/tables.dart' as const_table;

part 'krankheiten.g.dart';

@HiveType(typeId: 1)
class Krankheiten {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  int? krankheitstyp;

  @HiveField(3)
  List<String>? synonyme;

  @HiveField(4)
  List<int>? symptomImmer;

  @HiveField(5)
  List<int>? symptomHaeufig;

  @HiveField(6)
  List<int>? symptomSelten;

  @HiveField(7)
  int? symptomDauerWochen;

  @HiveField(8)
  List<String>? differenzialdiagnosen;

  @HiveField(9)
  List<int>? typischeRassen;

  @HiveField(10)
  List<int>? geschlechtAusschliesslich;

  @HiveField(11)
  List<int>? geschlechtTypisch;

  @HiveField(12)
  int? alterMin;

  @HiveField(13)
  int? alterMax;

  @HiveField(14)
  String? informationen;

  @HiveField(15)
  String? sofortmassnahmen;

  @HiveField(16)
  bool? krankheitHaeufig;

  @HiveField(17)
  bool? krankheitSelten;

  Krankheiten({
    this.id,
    this.name,
    this.krankheitstyp,
    this.synonyme,
    this.symptomImmer,
    this.symptomHaeufig,
    this.symptomSelten,
    this.symptomDauerWochen,
    this.differenzialdiagnosen,
    this.typischeRassen,
    this.geschlechtAusschliesslich,
    this.geschlechtTypisch,
    this.alterMin,
    this.alterMax,
    this.informationen,
    this.sofortmassnahmen,
    this.krankheitHaeufig,
    this.krankheitSelten
  });

  Krankheiten.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    krankheitstyp = json['krankheitstyp'];
    synonyme = (json['synonyme'] != null) ? List<String>.from(json['synonyme']) : null;
    symptomImmer = (json['symptom_immer'] != null) ? List<int>.from(json['symptom_immer']) : null;
    symptomHaeufig = (json['symptom_haeufig'] != null) ? List<int>.from(json['symptom_haeufig']) : null;
    symptomSelten = (json['symptom_selten'] != null) ? List<int>.from(json['symptom_selten']) : null;
    symptomDauerWochen = json['symptom_dauer_wochen'];
    differenzialdiagnosen = (json['differenzialdiagnosen'] != null) ? List<String>.from(json['differenzialdiagnosen']) : null;
    typischeRassen = (json['typische_rassen'] != null) ? List<int>.from(json['typische_rassen']) : null;
    geschlechtAusschliesslich = (json['geschlecht_ausschließlich'] != null) ? List<int>.from(json['geschlecht_ausschließlich']) : null;
    geschlechtTypisch = (json['geschlecht_typisch'] != null) ? List<int>.from(json['geschlecht_typisch']) : null;
    alterMin = json['alter_min'];
    alterMax = json['alter_max'];
    informationen = json['informationen'];
    sofortmassnahmen = json['sofortmaßnahmen'];
    krankheitHaeufig = json['krankheit_haeufig'];
    krankheitSelten = json['krankheit_selten'];
  }

  DataRow toDataRow(Map<String, Map<int, String>> tables) {
    return DataRow(cells: [
      DataCell(Text(id.toString())),
      DataCell(Text(name.toString())),
      DataCell(Text(tables[const_table.krankheitstyp]![krankheitstyp].toString())),
      DataCell(Text(synonyme != null ? synonyme!.join('\n') : "")),
      DataCell(Text(symptomImmer != null ? listToStringReplace(symptomImmer!, tables[const_table.symptom]!) : "")),
      DataCell(Text(symptomHaeufig != null ? listToStringReplace(symptomHaeufig!, tables[const_table.symptom]!) : "")),
      DataCell(Text(symptomSelten != null ? listToStringReplace(symptomSelten!, tables[const_table.symptom]!) : "")),
      DataCell(Text(symptomDauerWochen != null ? symptomDauerWochen.toString() : "")),
      DataCell(Text(differenzialdiagnosen != null ? differenzialdiagnosen!.join('\n') : "")),
      DataCell(Text(typischeRassen != null ? listToStringReplace(typischeRassen!, tables[const_table.pferderasse]!) : "")),
      DataCell(Text(geschlechtAusschliesslich != null ? listToStringReplace(geschlechtAusschliesslich!, tables[const_table.pferdegeschlecht]!) : "")),
      DataCell(Text(geschlechtTypisch != null ? listToStringReplace(geschlechtTypisch!, tables[const_table.pferdegeschlecht]!) : "")),
      DataCell(Text(alterMin != null ? alterMin.toString() : "")),
      DataCell(Text(alterMax != null ? alterMax.toString() : "")),
      DataCell(Text(informationen != null ? informationen.toString() : "")),
      DataCell(Text(sofortmassnahmen != null ? sofortmassnahmen.toString() : "")),
      DataCell(Text(krankheitHaeufig != null ? krankheitHaeufig.toString() : "")),
      DataCell(Text(krankheitSelten != null ? krankheitSelten.toString() : "")),
    ]);
  }

  String listToStringReplace(List<int> numList, Map<int, String> replaceMap) {
    String s = "";
    for (var element in numList) {
      if (replaceMap[element] != null) {
        s += replaceMap[element]!;
        s += "\n";
      }
    }
    return s;
  }
}