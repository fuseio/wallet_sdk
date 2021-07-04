import 'package:dio/dio.dart';

abstract class BackendApi {
  final Dio _dio;
  String? _jwtToken;

  BackendApi(
    this._dio,
    String baseUrl,
  ) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = Map.from({"Content-Type": 'application/json'});
  }

  Options get options => Options(
        headers: {"Authorization": "Bearer $_jwtToken"},
      );

  void setJwtToken(String jwtToken) {
    _jwtToken = jwtToken;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool auth = false,
  }) async {
    print('GET $endpoint');
    Response response;
    if (auth) {
      response = await _dio.get(
        '/$endpoint',
        options: options,
      );
    } else {
      response = await _dio.get(endpoint);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic body,
    bool auth = false,
  }) async {
    print('POST $endpoint $body');
    Response response;
    if (auth) {
      response = await _dio.post(
        '/$endpoint',
        data: body,
        options: options,
      );
    } else {
      response = await _dio.post(
        '/$endpoint',
        data: body,
      );
    }
    return response.data;
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic body,
    bool auth = false,
  }) async {
    print('POST $endpoint $body');
    Response response;
    if (auth) {
      response = await _dio.put(
        '/$endpoint',
        data: body,
        options: options,
      );
    } else {
      response = await _dio.put(
        '/$endpoint',
        data: body,
      );
    }
    return response.data;
  }
}
