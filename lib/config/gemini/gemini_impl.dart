import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiImpl {
  final Dio _http = Dio(BaseOptions(baseUrl: dotenv.env['ENDPOINT_API'] ?? ''));

  Future<String> getResponse(String message) async {
    try {
      final body = jsonEncode({"prompt": message});
      final response = await _http.post('/basic-prompt', data: body);

      return response.data;
    } catch (e) {
      print(e);
      throw Exception("Can't get Gemini response");
    }
  }
}
