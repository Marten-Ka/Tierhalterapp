// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'krankheiten.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KrankheitenAdapter extends TypeAdapter<Krankheiten> {
  @override
  final int typeId = 1;

  @override
  Krankheiten read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Krankheiten(
      id: fields[0] as int?,
      name: fields[1] as String?,
      krankheitstyp: fields[2] as int?,
      synonyme: (fields[3] as List?)?.cast<String>(),
      symptomImmer: (fields[4] as List?)?.cast<int>(),
      symptomHaeufig: (fields[5] as List?)?.cast<int>(),
      symptomSelten: (fields[6] as List?)?.cast<int>(),
      symptomDauerWochen: fields[7] as int?,
      differenzialdiagnosen: (fields[8] as List?)?.cast<String>(),
      typischeRassen: (fields[9] as List?)?.cast<int>(),
      geschlechtAusschliesslich: (fields[10] as List?)?.cast<int>(),
      geschlechtTypisch: (fields[11] as List?)?.cast<int>(),
      alterMin: fields[12] as int?,
      alterMax: fields[13] as int?,
      informationen: fields[14] as String?,
      sofortmassnahmen: (fields[15] as List?)?.cast<String>(),
      krankheitHaeufig: fields[16] as bool?,
      krankheitSelten: fields[17] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Krankheiten obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.krankheitstyp)
      ..writeByte(3)
      ..write(obj.synonyme)
      ..writeByte(4)
      ..write(obj.symptomImmer)
      ..writeByte(5)
      ..write(obj.symptomHaeufig)
      ..writeByte(6)
      ..write(obj.symptomSelten)
      ..writeByte(7)
      ..write(obj.symptomDauerWochen)
      ..writeByte(8)
      ..write(obj.differenzialdiagnosen)
      ..writeByte(9)
      ..write(obj.typischeRassen)
      ..writeByte(10)
      ..write(obj.geschlechtAusschliesslich)
      ..writeByte(11)
      ..write(obj.geschlechtTypisch)
      ..writeByte(12)
      ..write(obj.alterMin)
      ..writeByte(13)
      ..write(obj.alterMax)
      ..writeByte(14)
      ..write(obj.informationen)
      ..writeByte(15)
      ..write(obj.sofortmassnahmen)
      ..writeByte(16)
      ..write(obj.krankheitHaeufig)
      ..writeByte(17)
      ..write(obj.krankheitSelten);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KrankheitenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
