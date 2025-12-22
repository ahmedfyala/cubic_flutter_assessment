

part of 'location_model.dart';





class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 0;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      address: fields[3] as String,
      lat: fields[4] as double,
      lng: fields[5] as double,
      isActive: fields[6] as bool,
      services: (fields[7] as List?)?.cast<String>(),
      phone: fields[8] as String?,
      workingHours: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.lat)
      ..writeByte(5)
      ..write(obj.lng)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.services)
      ..writeByte(8)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.workingHours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
