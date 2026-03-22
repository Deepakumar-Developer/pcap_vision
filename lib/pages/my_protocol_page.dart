import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_protocol_diagram.dart';
import 'package:pcap_vision/widget/pcap_text.dart';
import 'package:pcap_vision/widget/pcap_widget.dart';

class MyProtocolPage extends StatefulWidget {
  final String protocolName;
  final int count;
  final List<Map<String, dynamic>> protocolData;
  const MyProtocolPage({
    super.key,
    required this.protocolName,
    required this.count,
    required this.protocolData,
  });

  @override
  State<MyProtocolPage> createState() => _MyProtocolPageState();
}

class _MyProtocolPageState extends State<MyProtocolPage> {
  PcapProtocolDiagram frameDiagram = PcapProtocolDiagram();
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
      });
    } else if (widget.protocolName.toLowerCase() == 'arp') {
      setState(() {
        diagram = frameDiagram.arp(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'ip') {
      setState(() {
        diagram = frameDiagram.ip(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'icmp') {
      setState(() {
        diagram = frameDiagram.icmp(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'tcp') {
      setState(() {
        diagram = frameDiagram.tcp(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'udp') {
      setState(() {
        diagram = frameDiagram.udp(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'tls') {
      setState(() {
        diagram = frameDiagram.tls(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'dhcp') {
      setState(() {
        diagram = frameDiagram.dhcp(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'dns') {
      setState(() {
        diagram = frameDiagram.dns(context);
      });
    } else if (widget.protocolName.toLowerCase() == 'http') {
      setState(() {
        diagram = frameDiagram.http(context);
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
              child: Container(
                height: height(context),

                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                // child: ProtocolDetailWidget(protocolData: widget.protocolData),
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
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      height: height(context) - 256,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: diagram),
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
