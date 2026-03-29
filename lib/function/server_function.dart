import 'dart:typed_data';

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
        final data = jsonDecode(response.body);
        return data['path'];
      } else {
        return "404 Error: ${response.statusCode}";
      }
    } catch (e) {
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
        final data = jsonDecode(response.body);
        return (data['interface'] as List)
            .map((item) => List<String>.from(item))
            .toList();
      } else {
        return [
          ["404 Error: ${response.statusCode}"],
        ];
      }
    } catch (e) {
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
        final data = jsonDecode(response.body);
        return data['output_file'];
      } else {
        return "404 Error: ${response.statusCode}";
      }
    } catch (e) {
      return "404 Connection Error: $e";
    }
  }

  Future<List<Map<String, dynamic>>> fetchPCAP(
    String remotePath,
    String type,
  ) async {
    List<String> routes = [
      '',
      '/metadata',
      '/ipAddress',
      '/macAddress',
      '/get_protocols',
      '/get_osi',
    ];
    List<Map<String, dynamic>> results = [];

    for (var route in routes) {
      final url = Uri.parse('$baseUrl/analyze$route?type=$type');
      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({"path": remotePath.trim()}),
        );

        if (response.statusCode == 200) {
          results.add({
            'route': route,
            'data': jsonDecode(response.body) as Map<String, dynamic>,
          });
          await Future.delayed(Duration(seconds: 1));
        } else {
          return [];
        }
      } catch (e) {
        return [];
      }
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> fetchPCAPfromBytes(
    Uint8List pcapBytes,
    String name,
    String type,
  ) async {
    List<String> routes = [
      '',
      '/metadata',
      '/ipAddress',
      '/macAddress',
      '/get_protocols',
      '/get_osi',
    ];
    List<Map<String, dynamic>> results = [];

    for (var route in routes) {
      final url = Uri.parse('$baseUrl/analyze$route?type=$type');
      try {
        var request = http.MultipartRequest('POST', url);

        // Use fromBytes to create the file object for the multipart request
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // Must match your Python: request.files['file']
            pcapBytes,
            filename: name,
          ),
        );

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          results.add({
            'route': route,
            'data': jsonDecode(response.body) as Map<String, dynamic>,
          });
          await Future.delayed(Duration(seconds: 1));
        } else {
          return [];
        }
      } catch (e) {
        return [];
      }
    }
    return results;
  }

  Future<Map<String, dynamic>> getprotocolData(
    String protocol,
    List<dynamic> protocolData,
  ) async {
    final url = Uri.parse('$baseUrl/get/$protocol');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"pcap_details": protocolData}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}
