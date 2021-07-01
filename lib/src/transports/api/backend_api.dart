import 'dart:convert';

import 'package:http/http.dart';

// const String API_baseUrl_URL = 'https://studio.fuse.io/api';

abstract class BackendApi {
  final String _baseUrl;
  final String _jwtToken;
  final Client _client;

  BackendApi(this._baseUrl, this._jwtToken, this._client);

  Map<String, dynamic> responseHandler(Response response) {
    print('response: ${response.statusCode}, ${response.reasonPhrase}');
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> obj = json.decode(response.body);
        return obj;
      case 401:
        throw 'Error! Unauthorized';
      default:
        throw 'Error! status: ${response.statusCode}, reason: ${response.reasonPhrase}';
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {bool auth = false}) async {
    print('GET $endpoint');
    Response response;
    String uri = '$_baseUrl/$endpoint';
    if (auth) {
      response = await _client.get(Uri.parse(uri),
          headers: {"Authorization": "Bearer $_jwtToken"});
    } else {
      response = await _client.get(Uri.parse(uri));
    }
    return responseHandler(response);
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {dynamic body, bool auth = false }) async {
    print('POST $endpoint $body');
    Response response;
    String uri = '$_baseUrl/$endpoint';
    body = body == null ? body : json.encode(body);
    if (auth) {
      response = await _client.post(Uri.parse(uri),
          headers: {
            "Authorization": "Bearer $_jwtToken",
            "Content-Type": 'application/json'
          },
          body: body);
    } else {
      response = await _client.post(Uri.parse(uri),
          body: body, headers: {"Content-Type": 'application/json'});
    }
    return responseHandler(response);
  }

    Future<Map<String, dynamic>> put(String endpoint,
      {dynamic body, bool auth = false }) async {
    print('POST $endpoint $body');
    Response response;
    String uri = '$_baseUrl/$endpoint';
    body = body == null ? body : json.encode(body);
    if (auth) {
      response = await _client.put(Uri.parse(uri),
          headers: {
            "Authorization": "Bearer $_jwtToken",
            "Content-Type": 'application/json'
          },
          body: body);
    } else {
      response = await _client.put(Uri.parse(uri),
          body: body, headers: {"Content-Type": 'application/json'});
    }
    return responseHandler(response);
  }
}