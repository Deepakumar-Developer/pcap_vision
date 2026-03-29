import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_text.dart';
import 'package:pcap_vision/widget/pcap_widget.dart';

class MyAboutPage extends StatefulWidget {
  const MyAboutPage({super.key});

  @override
  State<MyAboutPage> createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: pcapAppBar(context, page: 'about'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: width(context),
          height: height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
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
                'PCAP Vision was engineered to bridge the gap between raw binary packet data and actionable network intelligence.',
                fontSize: 14,
              ),
              PcapText(
                'Capture -> Process -> Visualize',
                fontSize: 14,
                isBold: true,
                color: Theme.of(context).colorScheme.primary,
              ),
              PcapText(
                'Our mission is to empower users to effortlessly capture, process, and visualize network traffic.\nBy transforming complex packet data into clear, actionable insights, we enable our users to stay one step ahead of potential threats and optimize their network performance.',
                fontSize: 14,
                textAlign: .center,
              ),
              PcapText(
                'Version 1.0.1 © ${DateTime.now().year} Pcap Vision',
                fontSize: 12,
                color: Theme.of(context).colorScheme.tertiary,
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
