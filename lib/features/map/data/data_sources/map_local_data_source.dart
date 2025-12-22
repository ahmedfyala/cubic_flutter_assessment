import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../models/location_model.dart';

abstract class MapLocalDataSource {
  Future<void> saveLocations(List<LocationModel> locations);
  Future<List<LocationModel>> getCachedLocations();
}

@LazySingleton(as: MapLocalDataSource)
class MapLocalDataSourceImpl implements MapLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  static const String _encryptionKeyName = 'hive_encryption_key';
  static const String _boxName = 'encrypted_locations';

  MapLocalDataSourceImpl(this._secureStorage);

  Future<List<int>> _getEncryptionKey() async {
    final containsKey = await _secureStorage.containsKey(
      key: _encryptionKeyName,
    );
    if (!containsKey) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _encryptionKeyName,
        value: base64UrlEncode(key),
      );
    }
    final keyString = await _secureStorage.read(key: _encryptionKeyName);
    return base64Url.decode(keyString!);
  }

  @override
  Future<void> saveLocations(List<LocationModel> locations) async {
    final encryptionKey = await _getEncryptionKey();
    final box = await Hive.openBox<LocationModel>(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await box.clear();
    await box.addAll(locations);
  }

  @override
  Future<List<LocationModel>> getCachedLocations() async {
    final encryptionKey = await _getEncryptionKey();
    final box = await Hive.openBox<LocationModel>(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    return box.values.toList();
  }
}
