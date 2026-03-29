import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_text.dart';
import 'package:pcap_vision/widget/pcap_widget.dart';

class MyHelpPage extends StatefulWidget {
  const MyHelpPage({super.key});

  @override
  State<MyHelpPage> createState() => _MyHelpPageState();
}

class _MyHelpPageState extends State<MyHelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: pcapAppBar(context, page: 'help'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: width(context),
          height: height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              Spacer(),
              Image.asset("assets/appIcon.png", width: 124, height: 124),
              PcapText(
                'Pcap Vision',
                fontSize: 36,
                isBold: true,
                color: Theme.of(context).colorScheme.primary,
              ),
              Spacer(),
              PcapText(
                'PCAP Vision: User Guide & Documentation',
                fontSize: 14,
                isBold: true,
              ),

              SizedBox(
                width: width(context) * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    PcapText(
                      'Connection Setup',
                      fontSize: 24,
                      isBold: true,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    PcapText(
                      'To analyze remote traffic, the app needs to connect to backend.\nHere is how to find your credentials:',
                      fontSize: 14,
                      textAlign: .left,
                    ),
                    Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      spacing: 8,
                      children: [
                        PcapText(
                          'Host(IP Address)  ',
                          fontSize: 14,
                          isBold: true,
                          textAlign: .left,
                        ),

                        PcapText(
                          'Windows: Open Command Prompt and type "ipconfig". Look for "IPv4 Address" (e.g., 192.168.1.8).\nLinux/Mac: Open Terminal and type ifconfig or ip addr',
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                          textAlign: .left,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      spacing: 8,
                      children: [
                        PcapText(
                          'User                        ',
                          fontSize: 14,
                          isBold: true,
                          textAlign: .left,
                        ),

                        PcapText(
                          'This is your computer\'s login name. In a terminal, type "whoami" to see the exact string.',
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                          textAlign: .left,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      spacing: 8,
                      children: [
                        PcapText(
                          'Password               ',
                          fontSize: 14,
                          isBold: true,
                          textAlign: .left,
                        ),

                        PcapText(
                          'The password you use to log into that specific machine.',
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                          textAlign: .left,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      spacing: 8,
                      children: [
                        PcapText(
                          'Tshark Path           ',
                          fontSize: 14,
                          isBold: true,
                          textAlign: .left,
                        ),

                        PcapText(
                          'The location where Wireshark/Tshark is installed.\nExample: C:\\\\Program Files\\\\Wireshark\\\\tshark.exe \n(Remember to use double backslashes \\\\ in the input field).',
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                          textAlign: .left,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
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
