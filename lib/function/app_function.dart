// ignore_for_file: unnecessary_getters_setters

import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pcap_vision/function/server_function.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

String? fileName;

Future<List<dynamic>> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pcap', 'pcapng', 'cap'],
    withData: true,
  );

  if (result != null) {
    return await processFile(result.files.first.name, result.files.first.bytes);
  }
  return [];
}

Future<List<dynamic>> processFile(String name, Uint8List? bytes) async {
  fileName = name;

  List<dynamic> response = await PcapServer().fetchPCAPfromBytes(
    bytes!,
    name,
    'bytes',
  );

  return response;
}

void msg(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: PcapText(text, fontSize: 12, textAlign: .left),
      padding: EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
    ),
  );
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

// IP Data Models
class IPData {
  IPData(this.ip, this.count);
  final String ip;
  final int count;
  String get fullLabel => ip;
}

// MAC Data Models
class MACData {
  MACData(this.mac, this.count);
  final String mac;
  final int count;
  String get fullLabel => mac;
}

// Conversation Data Model
class ConversationData {
  ConversationData(this.shortLabel, this.count, this.fullLabel);
  final String shortLabel;
  final int count;
  final String fullLabel;
}

// OSI Layer Data Model
class LayerData {
  final String protocol;
  final int count;

  LayerData(this.protocol, this.count);
}

class GetData {
  static final GetData _instance = GetData._internal();
  factory GetData() => _instance;
  GetData._internal();

  Map<String, dynamic> _metaData = {
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

  Map<String, dynamic> _protocolData = {
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

  Map<String, dynamic> _ipAddrData = {
    "ip_endpoint_info": {
      "conversations": [
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
      "destination_ips": [
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
      "source_ips": [
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

  Map<String, dynamic> _macAddrData = {
    "mac_endpoint_info": {
      "conversations": [
        {
          "count": 104,
          "endpoints": ["44:95:3b:9f:37:80", "60:ff:9e:50:6a:2c"],
        },
        {
          "count": 30,
          "endpoints": ["2c:6d:c1:25:b4:ad", "ff:ff:ff:ff:ff:ff"],
        },
      ],
      "destination_macs": [
        {"count": 51, "mac": "60:ff:9e:50:6a:2c"},
        {"count": 53, "mac": "44:95:3b:9f:37:80"},
        {"count": 30, "mac": "ff:ff:ff:ff:ff:ff"},
      ],
      "source_macs": [
        {"count": 51, "mac": "44:95:3b:9f:37:80"},
        {"count": 53, "mac": "60:ff:9e:50:6a:2c"},
        {"count": 30, "mac": "2c:6d:c1:25:b4:ad"},
      ],
    },
    "msg": "MAC endpoint analysis complete",
  };

  Map<String, dynamic> _osiLayerData = {
    "msg": "OSI layer mapping complete",
    "osi_mapping": {
      "0": {"count": 0, "data": []},
      "1": {"count": 0, "data": []},
      "2": {
        "count": 32,
        "data": [
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
          {"layer_name": "Data Link", "summary": "ARP (Hardware Address)"},
          {"layer_name": "Data Link", "summary": "Ethernet Frame"},
        ],
      },
      "3": {
        "count": 8,
        "data": [
          {"layer_name": "Network", "summary": "IP (142.250.67.42)"},
          {"layer_name": "Network", "summary": "IP (142.250.67.42)"},
          {"layer_name": "Network", "summary": "IP (192.168.1.15)"},
          {"layer_name": "Network", "summary": "IP (192.168.1.15)"},
          {"layer_name": "Network", "summary": "IP (192.168.1.15)"},
          {"layer_name": "Network", "summary": "IP (142.250.67.35)"},
          {"layer_name": "Network", "summary": "IP (192.168.1.15)"},
          {"layer_name": "Network", "summary": "IP (199.232.210.172)"},
        ],
      },
      "4": {
        "count": 15,
        "data": [
          {"layer_name": "Transport", "summary": "UDP (Port: 63257)"},
          {"layer_name": "Transport", "summary": "UDP (Port: 63257)"},
          {"layer_name": "Transport", "summary": "UDP (Port: 443)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 80)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 80)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 61307)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 80)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 61308)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 61308)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 80)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 443)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 61306)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 443)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 50468)"},
          {"layer_name": "Transport", "summary": "TCP (Port: 443)"},
        ],
      },
      "5": {"count": 0, "data": []},
      "6": {
        "count": 15,
        "data": [
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
          {"layer_name": "Presentation", "summary": "Encrypted (TLS/SSL)"},
        ],
      },
      "7": {
        "count": 8,
        "data": [
          {"layer_name": "Application", "summary": "DNS"},
          {"layer_name": "Application", "summary": "DNS"},
          {"layer_name": "Application", "summary": "DNS"},
          {"layer_name": "Application", "summary": "DNS"},
          {"layer_name": "Application", "summary": "DNS"},
          {"layer_name": "Application", "summary": "DNS"},
          {"layer_name": "Application", "summary": "DNS"},
          {"layer_name": "Application", "summary": "DNS"},
        ],
      },
    },
  };

  Map<String, dynamic> _pcapData = {
    "msg": "analysis complete",
    "packet_details": [
      {
        "ETHERNET": {
          "dst": "60:ff:9e:50:6a:2c",
          "src": "44:95:3b:9f:37:80",
          "type": 2048,
        },
        "IP": {
          "chksum": 43519,
          "dst": "192.168.1.15",
          "flags": "Flag 2 (DF)",
          "frag": 0,
          "id": 0,
          "ihl": 5,
          "len": 146,
          "options": [],
          "proto": 17,
          "src": "142.250.67.42",
          "tos": 128,
          "ttl": 60,
          "version": 4,
        },
        "UDP": {"chksum": 3136, "dport": 63257, "len": 126, "sport": 443},
      },
      {
        "ETHERNET": {
          "dst": "60:ff:9e:50:6a:2c",
          "src": "44:95:3b:9f:37:80",
          "type": 2048,
        },
        "IP": {
          "chksum": 43519,
          "dst": "192.168.1.15",
          "flags": "Flag 2 (DF)",
          "frag": 0,
          "id": 0,
          "ihl": 5,
          "len": 146,
          "options": [],
          "proto": 17,
          "src": "142.250.67.42",
          "tos": 128,
          "ttl": 60,
          "version": 4,
        },
        "UDP": {"chksum": 42857, "dport": 63257, "len": 126, "sport": 443},
      },
      {
        "ETHERNET": {
          "dst": "44:95:3b:9f:37:80",
          "src": "60:ff:9e:50:6a:2c",
          "type": 2048,
        },
        "IP": {
          "chksum": 13411,
          "dst": "142.250.67.42",
          "flags": "Flag 2 (DF)",
          "frag": 0,
          "id": 12912,
          "ihl": 5,
          "len": 62,
          "options": [],
          "proto": 17,
          "src": "192.168.1.15",
          "tos": 0,
          "ttl": 128,
          "version": 4,
        },
        "UDP": {"chksum": 45703, "dport": 443, "len": 42, "sport": 63257},
      },
      {
        "ETHERNET": {
          "dst": "44:95:3b:9f:37:80",
          "src": "60:ff:9e:50:6a:2c",
          "type": 2048,
        },
        "IP": {
          "chksum": 6630,
          "dst": "142.250.67.35",
          "flags": "Flag 2 (DF)",
          "frag": 0,
          "id": 19733,
          "ihl": 5,
          "len": 40,
          "options": [],
          "proto": 6,
          "src": "192.168.1.15",
          "tos": 0,
          "ttl": 128,
          "version": 4,
        },
        "TCP": {
          "ack": 1643721517,
          "chksum": 32462,
          "dataofs": 5,
          "dport": 80,
          "flags": "Flag 17 (FA)",
          "options": [],
          "reserved": 0,
          "seq": 21435897,
          "sport": 61307,
          "urgptr": 0,
          "window": 254,
        },
      },
      {
        "ETHERNET": {
          "dst": "44:95:3b:9f:37:80",
          "src": "60:ff:9e:50:6a:2c",
          "type": 2048,
        },
        "IP": {
          "chksum": 24726,
          "dst": "199.232.210.172",
          "flags": "Flag 2 (DF)",
          "frag": 0,
          "id": 15853,
          "ihl": 5,
          "len": 40,
          "options": [],
          "proto": 6,
          "src": "192.168.1.15",
          "tos": 0,
          "ttl": 128,
          "version": 4,
        },
        "TCP": {
          "ack": 2332060616,
          "chksum": 17589,
          "dataofs": 5,
          "dport": 80,
          "flags": "Flag 17 (FA)",
          "options": [],
          "reserved": 0,
          "seq": 2070457300,
          "sport": 61308,
          "urgptr": 0,
          "window": 255,
        },
      },
      {
        "ETHERNET": {
          "dst": "60:ff:9e:50:6a:2c",
          "src": "44:95:3b:9f:37:80",
          "type": 2048,
        },
        "IP": {
          "chksum": 35625,
          "dst": "192.168.1.15",
          "flags": "Flag 0 ()",
          "frag": 0,
          "id": 8274,
          "ihl": 5,
          "len": 40,
          "options": [],
          "proto": 6,
          "src": "142.250.67.35",
          "tos": 128,
          "ttl": 123,
          "version": 4,
        },
        "TCP": {
          "ack": 21435898,
          "chksum": 31662,
          "dataofs": 5,
          "dport": 61307,
          "flags": "Flag 17 (FA)",
          "options": [],
          "reserved": 0,
          "seq": 1643721517,
          "sport": 80,
          "urgptr": 0,
          "window": 1053,
        },
      },
      {
        "ETHERNET": {
          "dst": "44:95:3b:9f:37:80",
          "src": "60:ff:9e:50:6a:2c",
          "type": 2048,
        },
        "IP": {
          "chksum": 6629,
          "dst": "142.250.67.35",
          "flags": "Flag 2 (DF)",
          "frag": 0,
          "id": 19734,
          "ihl": 5,
          "len": 40,
          "options": [],
          "proto": 6,
          "src": "192.168.1.15",
          "tos": 0,
          "ttl": 128,
          "version": 4,
        },
        "TCP": {
          "ack": 1643721518,
          "chksum": 32461,
          "dataofs": 5,
          "dport": 80,
          "flags": "Flag 16 (A)",
          "options": [],
          "reserved": 0,
          "seq": 21435898,
          "sport": 61307,
          "urgptr": 0,
          "window": 254,
        },
      },
      {
        "ETHERNET": {
          "dst": "60:ff:9e:50:6a:2c",
          "src": "44:95:3b:9f:37:80",
          "type": 2048,
        },
        "IP": {
          "chksum": 47066,
          "dst": "192.168.1.15",
          "flags": "Flag 2 (DF)",
          "frag": 0,
          "id": 10921,
          "ihl": 5,
          "len": 40,
          "options": [],
          "proto": 6,
          "src": "199.232.210.172",
          "tos": 0,
          "ttl": 60,
          "version": 4,
        },
        "TCP": {
          "ack": 2070457301,
          "chksum": 17784,
          "dataofs": 5,
          "dport": 61308,
          "flags": "Flag 16 (A)",
          "options": [],
          "reserved": 0,
          "seq": 2332060616,
          "sport": 80,
          "urgptr": 0,
          "window": 60,
        },
      },
    ],
    "packet_summaries": [
      "Ether / IP / UDP 142.250.67.42:https > 192.168.1.15:63257 / Raw",
      "Ether / IP / UDP 192.168.1.15:63257 > 142.250.67.42:https / Raw",
      "Ether / IP / TCP 192.168.1.15:61307 > 142.250.67.35:http FA",
      "Ether / ARP who has 192.168.1.205 says 192.168.1.8",
      "Ether / IP / UDP 192.168.1.15:55972 > 34.49.23.1:https / Raw",
      "Ether / IP / UDP / DNS Qry b'www.google-analytics.com.'",
      "Ether / IP / UDP / DNS Ans 172.217.24.14",
      "Ether / IP / TCP 192.168.1.15:59171 > 172.64.149.23:http A",
    ],
  };

  Map<String, dynamic> _protocolInfo = {
    "fields": [
      {
        "chksum": 43519,
        "dst": "192.168.1.15",
        "flags": "Flag 2 (DF)",
        "frag": 0,
        "id": 0,
        "ihl": 5,
        "len": 146,
        "options": [],
        "proto": 17,
        "src": "142.250.67.42",
        "tos": 128,
        "ttl": 60,
        "version": 4,
      },
      {
        "chksum": 43519,
        "dst": "192.168.1.15",
        "flags": "Flag 2 (DF)",
        "frag": 0,
        "id": 0,
        "ihl": 5,
        "len": 146,
        "options": [],
        "proto": 17,
        "src": "142.250.67.42",
        "tos": 128,
        "ttl": 60,
        "version": 4,
      },
      {
        "chksum": 43519,
        "dst": "192.168.1.15",
        "flags": "Flag 2 (DF)",
        "frag": 0,
        "id": 0,
        "ihl": 5,
        "len": 146,
        "options": [],
        "proto": 17,
        "src": "142.250.67.42",
        "tos": 128,
        "ttl": 60,
        "version": 4,
      },
      {
        "chksum": 43519,
        "dst": "192.168.1.15",
        "flags": "Flag 2 (DF)",
        "frag": 0,
        "id": 0,
        "ihl": 5,
        "len": 146,
        "options": [],
        "proto": 17,
        "src": "142.250.67.42",
        "tos": 128,
        "ttl": 60,
        "version": 4,
      },
    ],
    "msg": "protocol info fetched",
    "protocol": "IP",
  };

  set metaData(Map<String, dynamic> val) => _metaData = val;
  set protocolData(Map<String, dynamic> val) => _protocolData = val;
  set ipAddrData(Map<String, dynamic> val) => _ipAddrData = val;
  set macAddrData(Map<String, dynamic> val) => _macAddrData = val;
  set osiLayerData(Map<String, dynamic> val) => _osiLayerData = val;
  set pcapData(Map<String, dynamic> val) => _pcapData = val;
  set protocolInfo(Map<String, dynamic> val) => _protocolInfo = val;

  Map<String, dynamic> get metaData => _metaData;
  Map<String, dynamic> get protocolData => _protocolData;
  Map<String, dynamic> get ipAddrData => _ipAddrData;
  Map<String, dynamic> get macAddrData => _macAddrData;
  Map<String, dynamic> get osiLayerData => _osiLayerData;
  Map<String, dynamic> get pcapData => _pcapData;
  Map<String, dynamic> get protocolInfo => _protocolInfo;
}
