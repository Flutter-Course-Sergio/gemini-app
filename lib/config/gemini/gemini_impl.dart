import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiImpl {
  final Dio http = Dio(BaseOptions(baseUrl: dotenv.env['ENDPOINT_API'] ?? ''));

  Future<String> getResponse(String message) async {
    final body = jsonEncode({"prompt": message});
    final response = await http.post('/basic-prompt', data: body);

    print(response.data);

    return 'Hola mundo desde Gemini';
  }
}
