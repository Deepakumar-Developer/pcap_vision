import 'package:flutter/material.dart';
import 'package:pcap_vision/function/app_function.dart';
import 'package:pcap_vision/widget/pcap_text.dart';
import 'package:pcap_vision/widget/pcap_widget.dart';

class MyResultPage extends StatefulWidget {
  const MyResultPage({super.key});

  @override
  State<MyResultPage> createState() => _MyResultPageState();
}

class _MyResultPageState extends State<MyResultPage> {
  Map<String, dynamic> metaData = GetData().metaData;
  Map<String, dynamic> protocolData = GetData().protocolData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: pcapAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: height(context),
              width: 300,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: metadataWidget(context, metaData),
            ),
            Container(
              height: height(context) - 138,
              width: width(context) - 300 - 250 - (24 * 4),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(
              height: height(context),
              width: 250,
              child: Column(
                spacing: 24,
                children: [
                  Expanded(
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: protocolWidget(context, protocolData),
                    ),
                  ),
                  Container(
                    height: 250,
                    width: 250,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: protocolChartWidget(context, protocolData),
                  ),
                ],
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
