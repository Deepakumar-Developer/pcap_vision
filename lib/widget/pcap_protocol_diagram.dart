import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

class PcapProtocolDefinition {
  String ethernet =
      'Ethernet \nThe "Envelope." It is the most common physical layer protocol. It uses MAC Addresses (hardware IDs like 00:0a:95:9d:68:16) to move data between two devices connected to the same switch. If Ethernet fails, the "cable" is essentially unplugged.';
  String arp =
      'Address Resolution Protocol \nThe "Translator." Computers talk using IP addresses, but switches move data using MAC addresses. ARP is the shout a computer makes: "Who has IP 192.168.1.1? Tell MAC 44:95:3b..." It bridges the gap between Layer 3 and Layer 2.';
  String ip =
      'Internet Protocol \n The "Postal Service." Every packet has an IP header containing a Source and Destination IP. It is responsible for "Routing"—deciding which path a packet should take across the world to reach its target. It doesn\'t care if the packet gets lost; it just handles the address.';
  String icmp =
      'Internet Control Message Protocol \nThe "Reporting Agency." ICMP doesn\'t carry user data (like your messages). It carries Status data. When you ping a server, you are using ICMP. If a router is too busy, it sends an ICMP "Source Quench" or "Destination Unreachable" back to you.';
  String tcp =
      'Transmission Control Protocol \nThe "Certified Mail." It is Connection-Oriented. It uses a 3-Way Handshake (SYN, SYN-ACK, ACK) to start. If a packet is lost, TCP notices and sends it again. It ensures that if you download a file, it arrives 100% complete and in the right order.';
  String udp =
      'User Datagram Protocol \nThe "Fire and Forget." It is Connectionless. It just pours data onto the wire as fast as possible. If a packet is lost, it’s gone forever. This is why Zoom calls "glitch" instead of pausing—UDP is skipping the lost data to stay real-time.';
  String tls =
      'Transport Layer Security \nThe "Armored Truck." Formerly known as SSL, TLS wraps your TCP data in a layer of Encryption. Even if a hacker captures the packet in your app, they will only see "RAW" gibberish because TLS has scrambled the contents using complex math.';
  String dhcp =
      'Dynamic Host Configuration Protocol \nThe "Registrar." When you join a Wi-Fi network, your phone has no IP. It sends a DHCP request, and the router "leases" you an IP address for a few hours. Without this, you\'d have to manually configure every device\'s network settings.';
  String dns =
      'Domain Name System \nThe "Internet Phonebook." Humans remember google.com, but routers only understand 142.250.67.42. DNS is the service that looks up the name and returns the number. If DNS is down, the internet feels "broken" even if the wires are fine.';
  String http =
      'Hypertext Transfer Protocol \nThe "Secure Web." This is the protocol used for almost all web browsing today. It is actually HTTP + TLS. It allows your browser to request images, text, and videos while ensuring that the connection to the server is private and verified.';
}

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
