import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class MapRemoteDataSource {
  Future<List<dynamic>> fetchRawLocations();
}

@LazySingleton(as: MapRemoteDataSource)
class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final Dio _dio;
  static const _url =
      'https://raw.githubusercontent.com/ahmed-hosni-1/location-cubic/refs/heads/main/branches_atms_10000.json';

  MapRemoteDataSourceImpl(this._dio);

  @override
  Future<List<dynamic>> fetchRawLocations() async {
    print("🌐 [MapRemoteDataSource] Fetching data from: $_url");

    try {
      final response = await _dio.get(_url);
      print(
        "📊 [MapRemoteDataSource] Data Type received: ${response.data.runtimeType}",
      );

      dynamic responseData = response.data;

      
      if (responseData is String) {
        print("📝 [MapRemoteDataSource] Data is String, decoding now...");
        responseData = jsonDecode(responseData);
      }

      if (responseData is List) {
        print(
          "✅ [MapRemoteDataSource] Successfully fetched ${responseData.length} items.",
        );
        return responseData as List<dynamic>;
      } else {
        print(
          "❌ [MapRemoteDataSource] Unexpected format: ${responseData.runtimeType}",
        );
        throw Exception(
          'Unexpected JSON format: expected List but got ${responseData.runtimeType}',
        );
      }
    } catch (e) {
      print("🚨 [MapRemoteDataSource] Dio Error: $e");
      rethrow;
    }
  }
}
