import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';

/// REST client tipis + JWT interceptor manual (sesuai api_gateway: Bearer JWT).
class ApiClient {
  final String baseUrl;
  String? token;
  ApiClient({this.baseUrl = ApiEndpoints.gateway});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final r = await http.post(Uri.parse('$baseUrl$path'), headers: _headers, body: jsonEncode(body));
    if (r.statusCode >= 400) throw Exception('POST $path: ${r.statusCode} ${r.body}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final r = await http.get(Uri.parse('$baseUrl$path'), headers: _headers);
    if (r.statusCode >= 400) throw Exception('GET $path: ${r.statusCode}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
