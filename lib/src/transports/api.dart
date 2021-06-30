import 'dart:convert';

import 'package:http/http.dart';

const String API_BASE_URL = 'https://studio.fuse.io/api';

abstract class ApiTransport {
  String _base = API_BASE_URL;
  Client _client = new Client();
  String _jwtToken = '';

  Map<String, dynamic> responseHandler(Response response) {
    print('response: ${response.statusCode}, ${response.reasonPhrase}');
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> obj = json.decode(response.body);
        return obj;
      case 401:
        throw 'Error! Unauthorized';
        break;
      default:
        throw 'Error! status: ${response.statusCode}, reason: ${response.reasonPhrase}';
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {bool auth = false}) async {
    print('GET $endpoint');
    Response response;
    String uri = '$_base/$endpoint';
    if (auth) {
      response = await _client.get(uri,
          headers: {"Authorization": "Bearer $_jwtToken"});
    } else {
      response = await _client.get(uri);
    }
    return responseHandler(response);
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {dynamic body, bool auth = false }) async {
    print('POST $endpoint $body');
    Response response;
    String uri = '$_base/$endpoint';
    body = body == null ? body : json.encode(body);
    if (auth) {
      response = await _client.post(uri,
          headers: {
            "Authorization": "Bearer $_jwtToken",
            "Content-Type": 'application/json'
          },
          body: body);
    } else {
      response = await _client.post(uri,
          body: body, headers: {"Content-Type": 'application/json'});
    }
    return responseHandler(response);
  }

    Future<Map<String, dynamic>> put(String endpoint,
      {dynamic body, bool auth = false }) async {
    print('POST $endpoint $body');
    Response response;
    String uri = '$_base/$endpoint';
    body = body == null ? body : json.encode(body);
    if (auth) {
      response = await _client.put(uri,
          headers: {
            "Authorization": "Bearer $_jwtToken",
            "Content-Type": 'application/json'
          },
          body: body);
    } else {
      response = await _client.put(uri,
          body: body, headers: {"Content-Type": 'application/json'});
    }
    return responseHandler(response);
  }
}