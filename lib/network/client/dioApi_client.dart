
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../apiClient/base_url.dart';

class DioClient{

  Dio? client;

  DioClient() {

    Map<String, dynamic> headers = {};
    headers['Content-Type'] = 'application/json';
    BaseOptions options = BaseOptions(
      baseUrl: BaseUrl().baseUrl,
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
      headers: headers,
    );

    //RequestOptions optionsMain;
    client = Dio(options);
    if (kDebugMode) {
      client!.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: true,
          request: true,
          requestBody: true));
    }

  }



  Future<Response> get(String endpoint,  String? accessToken , {dynamic body}) async {
    // Define your headers here
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $accessToken', // Include the dynamic access token
      'Custom-Header': 'custom_value', // Example custom header
    };

    return client!.request(
      endpoint,
      data: body,
      options: Options(
        method: "GET",
        contentType: 'application/json',
        headers: headers,
      ),
    );
  }


  Future<Response> post(String   endpoint,  String? accessToken , {dynamic body}) async {

    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $accessToken', // Include the dynamic access token
      'Custom-Header': 'custom_value', // Example custom header
    };
    Response response;
    try {
      response = await client!
          .request(endpoint, data: body, options: Options(method: "POST", headers: headers));
    } on DioException catch (e) {
      response = e.response!;
    }
    return response;
  }


  Future<Response> put(String endpoint, {dynamic body}) async {

    return client!
        .request(endpoint, data: body, options: Options(method: "PUT"));
  }

  Future<Response> delete(String endpoint, {dynamic body}) async {

    return client!
        .request(endpoint, data: body, options: Options(method: "DELETE"));
  }


}