import 'dart:convert';

//import 'package:HikeTracker/pages/home/models/filter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:requests/requests.dart';

class RestClient {
  RestClient();

  Future<Response> get({
    required String api,
    String? endpoint,
    Map<String, String>? headers,
    dynamic filter,
  }) async {
    final e = endpoint ?? dotenv.env['ENDPOINT'];

    return Requests.get(
      '$e$api',
      withCredentials: true,
      verify: false,
      persistCookies: false,
      queryParameters: filter?.toQueryParameters(),
    );
  }

  Future<Response> post({
    required String api,
    Map<String, dynamic>? body,
    String? endpoint,
  }) async {
    final e = endpoint ?? dotenv.env['ENDPOINT'];

    return Requests.post(
      '$e$api',
      bodyEncoding: RequestBodyEncoding.JSON,
      body: body,
      withCredentials: true,
      verify: false,
      persistCookies: false,
    );
  }

  Future<Response> delete({
    required String api,
    Map<String, dynamic>? body,
    String? endpoint,
  }) async {
    final e = endpoint ?? dotenv.env['ENDPOINT'];

    return Requests.delete(
      '$e$api',
      bodyEncoding: RequestBodyEncoding.JSON,
      body: body,
      withCredentials: true,
      verify: false,
      persistCookies: false,
    );
  }

  Future<Response> put({
    required String api,
    required Map<String, dynamic>? body,
    String? endpoint,
  }) async {
    final e = endpoint ?? dotenv.env['ENDPOINT'];

    return Requests.put(
      '$e$api',
      json: true,
      withCredentials: true,
      body: jsonEncode(body),
    );
  }
}
