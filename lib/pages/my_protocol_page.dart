// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_protocol_diagram.dart';
import 'package:pcap_vision/widget/pcap_text.dart';
import 'package:pcap_vision/widget/pcap_widget.dart';

class MyProtocolPage extends StatefulWidget {
  final String protocolName;
  final int count;
  final Map<String, dynamic> protocolInfo;
  const MyProtocolPage({
    super.key,
    required this.protocolName,
    required this.count,
    required this.protocolInfo,
  });

  @override
  State<MyProtocolPage> createState() => _MyProtocolPageState();
}

class _MyProtocolPageState extends State<MyProtocolPage> {
  PcapProtocolDiagram frameDiagram = PcapProtocolDiagram();
  String definition =
      'Oops!\nWe are working on fetching the protocol definition...';
  Widget diagram = Center(
    child: Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      spacing: 16,
      children: [
        PcapText('OOPs!', fontSize: 36, isBold: true),
        PcapText('No Frame Diagram Support', fontSize: 12),
        PcapText('We are Working...!', fontSize: 8),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.protocolName.toLowerCase() == 'ethernet') {
      setState(() {
        diagram = frameDiagram.ethernet(context);
        definition = PcapProtocolDefinition().ethernet;
      });
    } else if (widget.protocolName.toLowerCase() == 'arp') {
      setState(() {
        diagram = frameDiagram.arp(context);
        definition = PcapProtocolDefinition().arp;
      });
    } else if (widget.protocolName.toLowerCase() == 'ip') {
      setState(() {
        diagram = frameDiagram.ip(context);
        definition = PcapProtocolDefinition().ip;
      });
    } else if (widget.protocolName.toLowerCase() == 'icmp') {
      setState(() {
        diagram = frameDiagram.icmp(context);
        definition = PcapProtocolDefinition().icmp;
      });
    } else if (widget.protocolName.toLowerCase() == 'tcp') {
      setState(() {
        diagram = frameDiagram.tcp(context);
        definition = PcapProtocolDefinition().tcp;
      });
    } else if (widget.protocolName.toLowerCase() == 'udp') {
      setState(() {
        diagram = frameDiagram.udp(context);
        definition = PcapProtocolDefinition().udp;
      });
    } else if (widget.protocolName.toLowerCase() == 'tls') {
      setState(() {
        diagram = frameDiagram.tls(context);
        definition = PcapProtocolDefinition().tls;
      });
    } else if (widget.protocolName.toLowerCase() == 'dhcp') {
      setState(() {
        diagram = frameDiagram.dhcp(context);
        definition = PcapProtocolDefinition().dhcp;
      });
    } else if (widget.protocolName.toLowerCase() == 'dns') {
      setState(() {
        diagram = frameDiagram.dns(context);
        definition = PcapProtocolDefinition().dns;
      });
    } else if (widget.protocolName.toLowerCase() == 'http') {
      setState(() {
        diagram = frameDiagram.http(context);
        definition = PcapProtocolDefinition().http;
      });
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: pcapAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: height(context),

                child: Column(
                  spacing: 16,
                  crossAxisAlignment: .start,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      spacing: 8,
                      children: [
                        PcapText(
                          definition.split('\n')[0],
                          fontSize: 24,
                          isBold: true,
                        ),
                        PcapText(
                          definition.split('\n')[1],
                          fontSize: 16,
                          textAlign: .left,
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        width: .infinity,
                        child: PcapTable(
                          packetData: widget.protocolInfo['fields'] ?? [],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ColoredBox(
                color: Theme.of(context).colorScheme.secondary,
                child: SizedBox(width: 2, height: height(context)),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: height(context),
                child: Column(
                  crossAxisAlignment: .end,
                  spacing: 8,
                  children: [
                    PcapText(widget.protocolName, fontSize: 42, isBold: true),
                    PcapText(
                      'Appears ${widget.count} times',
                      fontSize: 18,
                      isBold: false,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(child: diagram),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
      ),
      persistentFooterButtons: [
        PcapText(
          'v1.0.1',
          fontSize: 12,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 14),
        PcapText('© ${DateTime.now().year} Pcap Vision', fontSize: 12),
        SizedBox(width: 14),
        Icon(
          Icons.help_outline,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}

class PcapTable extends StatelessWidget {
  final List<dynamic> packetData;

  const PcapTable({super.key, required this.packetData});

  @override
  Widget build(BuildContext context) {
    if (packetData.isEmpty) return Center(child: Text("No packets found"));

    List<String> columns = packetData[0].keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
            border: TableBorder.all(color: Colors.white30, width: 1),
            columns: columns.map((key) {
              return DataColumn(
                label: PcapText(
                  key.toUpperCase(),
                  fontSize: 14,
                  isBold: true,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            }).toList(),
            rows: packetData.map((pkt) {
              return DataRow(
                color: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
                cells: columns.map((key) {
                  return DataCell(
                    PcapText(
                      pkt[key].toString(),
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
