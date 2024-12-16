import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendAPI {
  static Future<Map<String, dynamic>> sendMessage(String prompt) async {
    final url = Uri.parse('http://127.0.0.1:5000');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'prompt': prompt});  // Changed 'message' to 'prompt'

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Successful response, parse JSON and return data
      return jsonDecode(response.body);
    } else {
      // Error occurred, handle accordingly
      throw Exception('Failed to send message to backend');
    }
  }
}
