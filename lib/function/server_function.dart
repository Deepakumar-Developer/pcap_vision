import 'package:http/http.dart' as http;
import 'dart:convert';

class PcapServer {
  // Use 10.0.2.2 if using Android Emulator, or your local IP for Web/Physical devices
  final String baseUrl = "http://127.0.0.1:8080";

  Future<String> getPath(String host, String user, String password) async {
    final url = Uri.parse('$baseUrl/cmd/path');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"host": host, "user": user, "pwd": password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Success: ${response.body}");
        final data = jsonDecode(response.body);
        return data['path'];
      } else {
        print("Server Error: ${response.statusCode}");
        return "404 Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Connection Error: $e");
      return "404 Connection Error: $e";
    }
  }

  Future<List<List<String>>> getInterface(
    String host,
    String user,
    String password,
    String path,
  ) async {
    final url = Uri.parse('$baseUrl/cmd/interface');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "host": host,
          "user": user,
          "pwd": password,
          "path": path.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Success: ${response.body}");
        final data = jsonDecode(response.body);
        return (data['interface'] as List)
            .map((item) => List<String>.from(item))
            .toList();
      } else {
        print("Server Error: ${response.statusCode}");
        return [
          ["404 Error: ${response.statusCode}"],
        ];
      }
    } catch (e) {
      print("Connection Error: $e");
      return [
        ["404 Connection Error: $e"],
      ];
    }
  }

  Future<String> getPCAP(
    String host,
    String user,
    String password,
    String path,
    String interfaceIndex,
  ) async {
    final url = Uri.parse('$baseUrl/cmd/get_pcap');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "host": host,
          "user": user,
          "pwd": password,
          "path": path.trim(),
          "index": interfaceIndex,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Success: ${response.body}");
        final data = jsonDecode(response.body);
        return data['output_file'];
      } else {
        print("Server Error: ${response.statusCode}");
        return "404 Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Connection Error: $e");
      return "404 Connection Error: $e";
    }
  }
}
