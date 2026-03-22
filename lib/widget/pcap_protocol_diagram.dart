import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

class PcapProtocolDiagram {
  Widget field(
    BuildContext context,
    String name, {
    double size = 12.0,
    bool isOptional = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isOptional ? Colors.white30 : Colors.white60,
          ),
        ),
        child: PcapText(
          name,
          fontSize: size,
          color: isOptional ? Colors.white30 : Colors.white,
        ),
      ),
    );
  }

  Widget ethernet(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                field(context, 'Destination MAC'),
                field(context, 'Source MAC'),
              ],
            ),
          ),
          field(context, 'EtherType'),
        ],
      ),
    );
  }

  Widget arp(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                field(context, 'Hardware Type'),
                field(context, 'Protocol Type'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'Hardware Size'),
                      field(context, 'Protocol Size'),
                    ],
                  ),
                ),
                field(context, 'OpCode'),
              ],
            ),
          ),
          field(context, 'Sender MAC Address'),
          field(context, 'Sender IP Address'),
          field(context, 'Target MAC Address'),
          field(context, 'Target MAC Address'),
        ],
      ),
    );
  }

  Widget ip(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'Version'),
                      field(context, 'Header Length'),
                      field(context, 'DSCP'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'ECN'),
                      field(context, 'Total Length'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                field(context, 'Identification'),
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'Flags'),
                      field(context, 'Fragment Offset'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'TTL'),
                      field(context, 'Protocol'),
                    ],
                  ),
                ),
                field(context, 'Header Checksum'),
              ],
            ),
          ),
          field(context, 'Source IP Address'),
          field(context, 'Destination IP Address'),
        ],
      ),
    );
  }

  Widget icmp(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [field(context, 'Type'), field(context, 'Code')],
                  ),
                ),

                field(context, 'Checksum'),
              ],
            ),
          ),
          field(context, 'Rest of Header'),
          field(context, 'Internet Protocol Version 4', isOptional: true),
          field(context, 'user DataGram Protocol', isOptional: true),
          field(context, 'Domain Name System', isOptional: true),
        ],
      ),
    );
  }

  Widget tcp(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                field(context, 'Source Port'),
                field(context, 'Destination Port'),
              ],
            ),
          ),
          field(context, 'Sequence Number'),
          field(context, 'Acknowledgment Number'),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'Header Length'),
                      field(context, 'Flags'),
                    ],
                  ),
                ),
                field(context, 'Window Size'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                field(context, 'Checksum'),
                field(context, 'Urgent Pointer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget udp(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                field(context, 'Source Port'),
                field(context, 'Destination Port'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [field(context, 'Length'), field(context, 'Checksum')],
            ),
          ),
          field(context, 'Payload', isOptional: true),
        ],
      ),
    );
  }

  Widget tls(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          field(context, 'Content Type'),
          field(context, 'Version'),
          field(context, 'Length'),
          field(context, 'Handshake Type', isOptional: true),
          field(context, 'TLS Version', isOptional: true),
          field(context, 'Random', isOptional: true),
          field(context, 'Session ID', isOptional: true),
          field(context, 'Cipher Suites', isOptional: true),
          field(context, 'Compression Methods', isOptional: true),
        ],
      ),
    );
  }

  Widget dhcp(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                field(context, 'Code'),
                field(context, 'Hardware Type'),
                field(context, 'Hardware Address Length'),
                field(context, 'Hops'),
              ],
            ),
          ),
          field(context, 'Transcation ID'),
          Expanded(
            child: Row(
              children: [field(context, 'Seconds'), field(context, 'Flags')],
            ),
          ),
          field(context, 'Client IP Address'),
          field(context, 'Your IP Address'),
          field(context, 'Server IP Address'),
          field(context, 'GateWay IP Address'),
          field(context, 'Client Hardware Address'),
          field(context, 'Server Name'),
          field(context, 'Boot File Name'),

          Expanded(
            child: Row(
              children: [
                field(context, 'magic Cookie'),
                field(context, 'Option'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dns(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                field(context, 'Transaction ID'),
                field(context, 'Flags'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                field(context, 'Question'),
                field(context, 'Answer RRs'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                field(context, 'Authority RRs'),
                field(context, 'Addiction RRs'),
              ],
            ),
          ),
          field(context, 'Queries', isOptional: true),
        ],
      ),
    );
  }

  Widget http(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'HTTP Version'),
                      field(context, 'Space'),
                      field(context, 'Status Code'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      field(context, 'Space'),
                      field(context, 'Status Phrase'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                field(context, 'Header Field Name'),
                field(context, 'Space'),
                field(context, 'Value'),
                field(context, 'Space'),
              ],
            ),
          ),
          field(context, '', isOptional: true),
          Expanded(
            child: Row(
              children: [
                field(context, 'Header Field Name'),
                field(context, 'Space'),
                field(context, 'Value'),
                field(context, 'Space'),
              ],
            ),
          ),
          field(context, 'Blank Line', isOptional: true),
          field(context, 'Message Body', isOptional: true),
        ],
      ),
    );
  }
}
