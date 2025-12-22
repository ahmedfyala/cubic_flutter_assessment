import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';

abstract class MapRemoteDataSource {
  Future<List<dynamic>> fetchRawLocations();
}

@LazySingleton(as: MapRemoteDataSource)
class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final Dio _dio;

  MapRemoteDataSourceImpl(this._dio);

  @override
  Future<List<dynamic>> fetchRawLocations() async {
    try {
      final response = await _dio.get(ApiConstants.locationsEndpoint);
      dynamic responseData = response.data;

      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      if (responseData is List) {
        return responseData as List<dynamic>;
      } else {
        throw Exception(
          'Unexpected JSON format: expected List but got ${responseData.runtimeType}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
