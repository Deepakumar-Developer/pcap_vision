import 'package:flutter/material.dart';
import 'package:pcap_vision/function/app_function.dart';
import 'package:pcap_vision/widget/pcap_button.dart';
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
  Map<String, dynamic> ipAddrData = GetData().ipAddrData;
  Map<String, dynamic> macAddrData = GetData().macAddrData;
  Map<String, dynamic> osiLayerData = GetData().osiLayerData;
  Map<String, dynamic> pcapData = GetData().pcapData;
  bool isTop = true;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    print('result page build');

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
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: height(context) - 138,
                  width: width(context) - 300 - 250 - (24 * 4),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(
                        height: height(context) - 174,
                        width: width(context) - 300 - 250 - (24 * 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: IpWidget(ipAddrData: ipAddrData)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: ColoredBox(
                                color: Theme.of(context).colorScheme.secondary,
                                child: SizedBox(
                                  width: 2,
                                  height: height(context),
                                ),
                              ),
                            ),
                            Expanded(
                              child: MacWidget(macAddrData: macAddrData),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height(context) - 174,
                        width: width(context) - 300 - 250 - (24 * 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: OSILayerWidget(osiLayerData: osiLayerData),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: ColoredBox(
                                color: Theme.of(context).colorScheme.secondary,
                                child: SizedBox(
                                  width: 2,
                                  height: height(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SummaryWidget(pcapData: pcapData),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                PcapIconButton(
                  icon: isTop ? Icons.arrow_circle_down : Icons.arrow_circle_up,
                  onPressed: () {
                    setState(() {
                      if (isTop) {
                        _pageController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _pageController.animateToPage(
                          0,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }

                      isTop = !isTop;
                    });
                  },
                ),
              ],
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
                      child: ProtocolWidget(
                        protocolData: protocolData,
                        data: pcapData['packet_details'],
                      ),
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
