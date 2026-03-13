import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

String? fileName;

Future<bool> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pcap', 'pcapng', 'cap'],
    withData: true,
  );

  if (result != null) {
    return processFile(result.files.first.name, result.files.first.bytes);
  }
  return false;
}

bool processFile(String name, Uint8List? bytes) {
  fileName = name;
  print("File Selected: $name");

  return true;
  // Here you would call your analyze() function
  // and pass the bytes to your Flask API
}

// Matadata and Protocol Data Models
class PacketData {
  PacketData(this.slot, this.packetCount);
  final int slot;
  final int packetCount;
}

// Protocoldata Model
class ProtocolData {
  ProtocolData(this.protocol, this.count);
  final String protocol;
  final int count;
}

class GetData {
  Map<String, dynamic> metaData = {
    "msg": "metadata analysis complete",
    "session_info": {
      "average_data_rate_mbps": 0.035784219097990816,
      "duration_seconds": 9.122457,
      "start_time": "2026-02-13T00:26:21.040254",
      "total_bytes": 40805,
      "total_packets": 100,
    },
    "traffic_timeline": [
      {"packet_count": 40, "slot": 1},
      {"packet_count": 50, "slot": 2},
      {"packet_count": 10, "slot": 3},
      {"packet_count": 23, "slot": 4},
      {"packet_count": 78, "slot": 5},
      {"packet_count": 45, "slot": 6},
      {"packet_count": 82, "slot": 7},
      {"packet_count": 102, "slot": 8},
      {"packet_count": 89, "slot": 9},
      {"packet_count": 92, "slot": 10},
    ],
  };

  Map<String, dynamic> protocolData = {
    "msg": "protocol analysis complete",
    "protocols": [
      {"count": 134, "protocol": "Ethernet"},
      {"count": 102, "protocol": "IP"},
      {"count": 62, "protocol": "TCP"},
      {"count": 56, "protocol": "Raw"},
      {"count": 40, "protocol": "UDP"},
      {"count": 32, "protocol": "ARP"},
      {"count": 16, "protocol": "HTTP"},
      {"count": 12, "protocol": "TLS"},
      {"count": 10, "protocol": "DNS"},
      {"count": 8, "protocol": "DNS Question Record"},
      {"count": 4, "protocol": "DNS Resource Record"},
      {"count": 2, "protocol": "DNS SOA Resource Record"},
    ],
  };

  Map<String, dynamic> ipAddrData = {
    "ip_endpoint_info": {
      "top_conversations": [
        {
          "count": 3,
          "endpoints": ["142.250.67.42", "192.168.1.15"],
        },
        {
          "count": 3,
          "endpoints": ["142.250.67.35", "192.168.1.15"],
        },
        {
          "count": 4,
          "endpoints": ["192.168.1.15", "199.232.210.172"],
        },
        {
          "count": 3,
          "endpoints": ["192.168.1.15", "40.126.17.133"],
        },
        {
          "count": 5,
          "endpoints": ["172.64.151.4", "192.168.1.15"],
        },
        {
          "count": 5,
          "endpoints": ["192.168.1.15", "34.8.7.18"],
        },
        {
          "count": 8,
          "endpoints": ["192.168.1.1", "192.168.1.15"],
        },
        {
          "count": 29,
          "endpoints": ["192.168.1.15", "34.49.23.1"],
        },
        {
          "count": 3,
          "endpoints": ["192.168.1.15", "44.245.66.99"],
        },
        {
          "count": 3,
          "endpoints": ["192.168.1.15", "35.244.251.182"],
        },
        {
          "count": 34,
          "endpoints": ["172.217.24.14", "192.168.1.15"],
        },
        {
          "count": 2,
          "endpoints": ["172.64.149.23", "192.168.1.15"],
        },
      ],
      "top_destination_ips": [
        {"count": 50, "ip": "192.168.1.15"},
        {"count": 1, "ip": "142.250.67.42"},
        {"count": 2, "ip": "142.250.67.35"},
        {"count": 2, "ip": "199.232.210.172"},
        {"count": 2, "ip": "40.126.17.133"},
        {"count": 2, "ip": "172.64.151.4"},
        {"count": 3, "ip": "34.8.7.18"},
        {"count": 4, "ip": "192.168.1.1"},
        {"count": 15, "ip": "34.49.23.1"},
        {"count": 2, "ip": "44.245.66.99"},
        {"count": 2, "ip": "35.244.251.182"},
        {"count": 16, "ip": "172.217.24.14"},
        {"count": 1, "ip": "172.64.149.23"},
      ],
      "top_source_ips": [
        {"count": 2, "ip": "142.250.67.42"},
        {"count": 52, "ip": "192.168.1.15"},
        {"count": 1, "ip": "142.250.67.35"},
        {"count": 2, "ip": "199.232.210.172"},
        {"count": 1, "ip": "40.126.17.133"},
        {"count": 3, "ip": "172.64.151.4"},
        {"count": 2, "ip": "34.8.7.18"},
        {"count": 4, "ip": "192.168.1.1"},
        {"count": 14, "ip": "34.49.23.1"},
        {"count": 1, "ip": "35.244.251.182"},
        {"count": 18, "ip": "172.217.24.14"},
        {"count": 1, "ip": "44.245.66.99"},
        {"count": 1, "ip": "172.64.149.23"},
      ],
    },
    "msg": "IP endpoint analysis complete",
  };
}
