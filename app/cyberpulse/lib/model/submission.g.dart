// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubmissionAdapter extends TypeAdapter<Submission> {
  @override
  final int typeId = 0;

  @override
  Submission read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Submission(
      formId: fields[0] as String?,
      name: fields[1] as String,
      email: fields[2] as String,
      birthDate: fields[3] as String,
      interestedArea: fields[4] as String,
      marketingUpdates: fields[5] as String,
      correspondence: fields[6] as String,
      latitude: fields[7] as double?,
      longitude: fields[8] as double?,
      submittedDate: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Submission obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.formId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.birthDate)
      ..writeByte(4)
      ..write(obj.interestedArea)
      ..writeByte(5)
      ..write(obj.marketingUpdates)
      ..writeByte(6)
      ..write(obj.correspondence)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.submittedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmissionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
