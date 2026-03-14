import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pcap_vision/function/app_function.dart';
import 'package:pcap_vision/widget/pcap_button.dart';
import 'package:pcap_vision/widget/pcap_input.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

double height(BuildContext context) => MediaQuery.of(context).size.height;

double width(BuildContext context) => MediaQuery.of(context).size.width;

PreferredSizeWidget pcapAppBar(BuildContext context) => AppBar(
  title: PcapText("Pcap Vision", fontSize: 20),
  elevation: 0,
  scrolledUnderElevation: 0,
  surfaceTintColor: Colors.transparent,
  backgroundColor: Theme.of(context).colorScheme.surface,
  actions: [
    PcapTextButton(onPressed: () {}, text: "About"),
    SizedBox(width: 24),
    PcapTextButton(onPressed: () {}, text: "Documentation"),
    SizedBox(width: 24),
    Image.asset("assets/appIcon.png", width: 24, height: 24),
    SizedBox(width: 24),
  ],
);

Widget pcapUploadArea(BuildContext context) {
  return Container(
    height: 250,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: 16),
        Text(
          "Drag and drop your file here",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Upload .pcap or .pcapng formats",
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        SizedBox(height: 20),
        PcapButton(
          text: "Browse Files",
          onPressed: () async {
            bool success = await pickFile();
            print("File picking result: $success");
          },
          width: 250,
        ),
      ],
    ),
  );
}

Widget pcapCaptureArea(
  BuildContext context,
  TextEditingController hostController,
  TextEditingController userController,
) {
  return SizedBox(
    width: double.infinity,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PcapInput(
          label: 'Host',
          hintText: 'Host Address',
          isRequired: true,
          controller: hostController,
          icon: Icons.computer,
        ),
        SizedBox(height: 24),
        PcapInput(
          label: 'User',
          hintText: 'User Name',
          isRequired: true,
          controller: userController,
          icon: Icons.person,
        ),
        SizedBox(height: 24),
      ],
    ),
  );
}

Widget pcapLoader(BuildContext context) {
  return Container(
    height: height(context),
    width: width(context),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    ),
    alignment: Alignment.center,
    child: LoadingAnimationWidget.halfTriangleDot(
      color: Theme.of(context).colorScheme.primary,
      size: 40,
    ),
  );
}

Widget metadataWidget(BuildContext context, Map<String, dynamic> metaData) {
  final List<PacketData> data = (metaData['traffic_timeline'] as List)
      .map(
        (item) => PacketData(item['slot'] as int, item['packet_count'] as int),
      )
      .toList();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      PcapText("Metadata Analysis", fontSize: 18, isBold: true),
      SizedBox(height: 8),
      PcapText(
        "Duration: ${metaData['session_info']['duration_seconds'].toString().substring(0, 4)} seconds",
        fontSize: 12,
      ),
      PcapText(
        "Total Packets: ${metaData['session_info']['total_packets']}",
        fontSize: 12,
      ),
      PcapText(
        "Total Bytes: ${metaData['session_info']['total_bytes']} bytes",
        fontSize: 12,
      ),
      PcapText(
        "Average Data Rate: ${metaData['session_info']['average_data_rate_mbps'].toString().substring(0, 4)} Mbps",
        fontSize: 12,
      ),
      SizedBox(height: 8),
      PcapText("Frames Arrival", fontSize: 18, isBold: true),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'Packet vs Time Slot',
              textStyle: GoogleFonts.spaceGrotesk(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: .bold,
                ),
              ),
            ),
            // Enable tooltip to see the 92 count on hover
            tooltipBehavior: TooltipBehavior(enable: true, header: 'Slot Data'),

            // X-Axis (Slots)
            primaryXAxis: NumericAxis(
              title: AxisTitle(
                text: 'Slot Index',
                textStyle: GoogleFonts.spaceGrotesk(
                  textStyle: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              labelStyle: GoogleFonts.spaceGrotesk(
                textStyle: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              majorGridLines: MajorGridLines(width: 0), // Clean look
            ),

            // Y-Axis (Count)
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: 'Packet Count',
                textStyle: GoogleFonts.spaceGrotesk(
                  textStyle: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              labelStyle: GoogleFonts.spaceGrotesk(
                textStyle: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),

            series: <CartesianSeries<PacketData, int>>[
              // Use CartesianSeries instead of ChartSeries
              ColumnSeries<PacketData, int>(
                dataSource: data,
                xValueMapper: (PacketData p, _) => p.slot,
                yValueMapper: (PacketData p, _) => p.packetCount,
                name: 'Packets',
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.blueAccent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class IpWidget extends StatefulWidget {
  final Map<String, dynamic> ipAddrData;
  const IpWidget({super.key, required this.ipAddrData});

  @override
  State<IpWidget> createState() => _IpWidgetState();
}

class _IpWidgetState extends State<IpWidget> {
  bool isDSView = true;

  @override
  Widget build(BuildContext context) {
    final List<IPData> destData =
        (widget.ipAddrData['ip_endpoint_info']['destination_ips'] as List)
            .map((e) => IPData(e['ip'], e['count'] as int))
            .toList();
    final List<IPData> sourceData =
        (widget.ipAddrData['ip_endpoint_info']['source_ips'] as List)
            .map((e) => IPData(e['ip'], e['count'] as int))
            .toList();

    final List<ConversationData> pairData =
        (widget.ipAddrData['ip_endpoint_info']['conversations'] as List).map((
          item,
        ) {
          List<String> endpoints = List<String>.from(item['endpoints']);
          String pairLabel =
              "${endpoints[0].substring(9)} ↔ ${endpoints[1].substring(9)}";
          return ConversationData(
            pairLabel,
            item['count'],
            "${endpoints[0]}\n${endpoints[1]}",
          );
        }).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        PcapText("IP Endpoint Analysis", fontSize: 18, isBold: true),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isDSView
              ? SfCartesianChart(
                  title: ChartTitle(
                    text: 'IP Traffic: Source vs Destination',
                    textStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    textStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: 'IP Stats',
                  ),

                  // X-Axis shows the IP addresses
                  primaryXAxis: CategoryAxis(
                    labelRotation: 45, // Rotated for readability
                    labelStyle: TextStyle(color: Colors.white54, fontSize: 0),
                    majorGridLines: MajorGridLines(width: 0),
                  ),

                  // Y-Axis shows packet counts
                  primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(color: Colors.white54),
                    title: AxisTitle(
                      text: 'IP Count',
                      textStyle: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  series: <CartesianSeries<IPData, String>>[
                    // --- SERIES 1: SOURCE IPs ---
                    ColumnSeries<IPData, String>(
                      name: 'Source',
                      dataSource: sourceData,
                      xValueMapper: (IPData data, _) => data.ip,
                      yValueMapper: (IPData data, _) => data.count,
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.circular(4),
                      spacing: 0.2, // Adds space between the groups
                    ),

                    // --- SERIES 2: DESTINATION IPs ---
                    ColumnSeries<IPData, String>(
                      name: 'Destination',
                      dataSource: destData,
                      xValueMapper: (IPData data, _) => data.ip,
                      yValueMapper: (IPData data, _) => data.count,
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.circular(4),
                      spacing: 0.2,
                    ),
                  ],
                )
              : SfCartesianChart(
                  title: ChartTitle(
                    text: 'IP Pairs',
                    textStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: 'IP Addresses',
                    builder:
                        (
                          dynamic data,
                          dynamic point,
                          dynamic series,
                          int pointIndex,
                          int seriesIndex,
                        ) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Pairs:\n${data.fullLabel}\nBcast: ${data.count}',
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                  ),

                  // X-Axis (Conversation Pairs)
                  primaryXAxis: CategoryAxis(
                    labelStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(color: Colors.white70, fontSize: 0),
                    ),
                    majorGridLines: MajorGridLines(width: 0),
                  ),

                  // Y-Axis (Packet Count)
                  primaryYAxis: NumericAxis(
                    labelStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    title: AxisTitle(
                      text: 'Packets',
                      textStyle: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  series: <CartesianSeries<ConversationData, String>>[
                    BarSeries<ConversationData, String>(
                      dataSource: pairData,
                      xValueMapper: (ConversationData d, _) => d.shortLabel,
                      yValueMapper: (ConversationData d, _) => d.count,
                      name: 'Traffic',
                      // Cyberpunk styling
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(5),
                      ),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: GoogleFonts.spaceGrotesk(
                          textStyle: TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.blueAccent],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                  ],
                ),
        ),
        PcapText('Total IP Count', fontSize: 14, isBold: true),
        PcapText(
          'Source: ${sourceData.length}\nDestination: ${destData.length}',
          fontSize: 12,
        ),
        PcapText('Total IP Pairs', fontSize: 14, isBold: true),
        PcapText(
          '${widget.ipAddrData['ip_endpoint_info']['conversations'].length}',
          fontSize: 12,
        ),
        Align(
          alignment: .center,
          child: PcapTextButton(
            text: isDSView ? 'View Pairs' : 'View Source/Destination',
            onPressed: () {
              setState(() {
                isDSView = !isDSView;
              });
            },
          ),
        ),
      ],
    );
  }
}

class MacWidget extends StatefulWidget {
  final Map<String, dynamic> macAddrData;
  const MacWidget({super.key, required this.macAddrData});

  @override
  State<MacWidget> createState() => _MacWidgetState();
}

class _MacWidgetState extends State<MacWidget> {
  bool isDSView = true;

  @override
  Widget build(BuildContext context) {
    final List<MACData> destData =
        (widget.macAddrData['mac_endpoint_info']['destination_macs'] as List)
            .map((e) => MACData(e['mac'], e['count'] as int))
            .toList();
    final List<MACData> sourceData =
        (widget.macAddrData['mac_endpoint_info']['source_macs'] as List)
            .map((e) => MACData(e['mac'], e['count'] as int))
            .toList();
    final List<ConversationData> pairData =
        (widget.macAddrData['mac_endpoint_info']['conversations'] as List).map((
          item,
        ) {
          List<String> endpoints = List<String>.from(item['endpoints']);
          String pairLabel =
              "${endpoints[0].substring(12)} ↔ ${endpoints[1].substring(12)}";
          return ConversationData(
            pairLabel,
            item['count'],
            "${endpoints[0]}\n${endpoints[1]}",
          );
        }).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        PcapText("MAC Endpoint Analysis", fontSize: 18, isBold: true),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isDSView
              ? SfCartesianChart(
                  title: ChartTitle(
                    text: 'MAC Traffic: Source vs Destination',
                    textStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    textStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: 'MAC Stats',
                  ),

                  // X-Axis shows the MAC addresses
                  primaryXAxis: CategoryAxis(
                    labelRotation: 45, // Rotated for readability
                    labelStyle: TextStyle(color: Colors.white54, fontSize: 0),
                    majorGridLines: MajorGridLines(width: 0),
                  ),

                  // Y-Axis shows packet counts
                  primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(color: Colors.white54),
                    title: AxisTitle(
                      text: 'MAC Count',
                      textStyle: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  series: <CartesianSeries<MACData, String>>[
                    // --- SERIES 1: SOURCE MACs ---
                    ColumnSeries<MACData, String>(
                      name: 'Source',
                      dataSource: sourceData,
                      xValueMapper: (MACData data, _) => data.mac,
                      yValueMapper: (MACData data, _) => data.count,
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.circular(4),
                      spacing: 0.2, // Adds space between the groups
                    ),

                    // --- SERIES 2: DESTINATION MACs ---
                    ColumnSeries<MACData, String>(
                      name: 'Destination',
                      dataSource: destData,
                      xValueMapper: (MACData data, _) => data.mac,
                      yValueMapper: (MACData data, _) => data.count,
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.circular(4),
                      spacing: 0.2,
                    ),
                  ],
                )
              : SfCartesianChart(
                  title: ChartTitle(
                    text: 'MAC Pairs',
                    textStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: 'MAC Addresses',
                    builder:
                        (
                          dynamic data,
                          dynamic point,
                          dynamic series,
                          int pointIndex,
                          int seriesIndex,
                        ) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Pairs:\n${data.fullLabel}\nBcast: ${data.count}',
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                  ),

                  // X-Axis (Conversation Pairs)
                  primaryXAxis: CategoryAxis(
                    labelStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(color: Colors.white70, fontSize: 0),
                    ),
                    majorGridLines: MajorGridLines(width: 0),
                  ),

                  // Y-Axis (Packet Count)
                  primaryYAxis: NumericAxis(
                    labelStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    title: AxisTitle(
                      text: 'Packets',
                      textStyle: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  series: <CartesianSeries<ConversationData, String>>[
                    BarSeries<ConversationData, String>(
                      dataSource: pairData,
                      xValueMapper: (ConversationData d, _) => d.shortLabel,
                      yValueMapper: (ConversationData d, _) => d.count,
                      name: 'Traffic',
                      // Cyberpunk styling
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(5),
                      ),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: GoogleFonts.spaceGrotesk(
                          textStyle: TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.blueAccent],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                  ],
                ),
        ),
        PcapText('Total MAC Count', fontSize: 14, isBold: true),
        PcapText(
          'Source: ${sourceData.length}\nDestination: ${destData.length}',
          fontSize: 12,
        ),
        PcapText('Total MAC Pairs', fontSize: 14, isBold: true),
        PcapText(
          '${widget.macAddrData['mac_endpoint_info']['conversations'].length}',
          fontSize: 12,
        ),
        Align(
          alignment: .center,
          child: PcapTextButton(
            text: isDSView ? 'View Pairs' : 'View Source/Destination',
            onPressed: () {
              setState(() {
                isDSView = !isDSView;
              });
            },
          ),
        ),
      ],
    );
  }
}

class OSILayerWidget extends StatefulWidget {
  final Map<String, dynamic> osiLayerData;
  const OSILayerWidget({super.key, required this.osiLayerData});
  @override
  State<OSILayerWidget> createState() => _OSILayerWidgetState();
}

class _OSILayerWidgetState extends State<OSILayerWidget> {
  String getLayerName(String key) {
    switch (key) {
      case "2":
        return "Data Link";
      case "3":
        return "Network";
      case "4":
        return "Transport";
      case "5":
        return "Session";
      case "6":
        return "Presentation";
      case "7":
        return "Application";
      default:
        return "Physical";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<OSIBubbleData> chartData = [];

    // Parse your JSON into Bubble Data
    widget.osiLayerData['osi_mapping'].forEach((layerKey, value) {
      Map<String, int> internalCounts = {};
      List dataList = value['data'];

      for (var item in dataList) {
        String name = item['summary'].toString().split(' ')[0];
        internalCounts[name] = (internalCounts[name] ?? 0) + 1;
      }

      internalCounts.forEach((proto, count) {
        chartData.add(
          OSIBubbleData(
            layer: int.parse(layerKey),
            protocol: proto,
            count: count,
            // We use the count to define size
            size: count.toDouble(),
          ),
        );
      });
    });

    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Protocol Density per OSI Layer',
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        primaryXAxis: NumericAxis(
          title: AxisTitle(
            text: 'OSI Layer',
            textStyle: TextStyle(color: Colors.white70),
          ),
          minimum: 1,
          maximum: 8,
          interval: 1,
          labelStyle: TextStyle(color: Colors.cyanAccent),
        ),
        primaryYAxis: NumericAxis(
          isVisible:
              false, // Hide Y axis as we only care about horizontal grouping
          minimum: 0,
          maximum: 10,
        ),
        tooltipBehavior: TooltipBehavior(enable: true, header: 'Protocol Info'),
        series: <CartesianSeries<OSIBubbleData, num>>[
          BubbleSeries<OSIBubbleData, num>(
            dataSource: chartData,
            xValueMapper: (OSIBubbleData data, _) => data.layer,
            yValueMapper: (OSIBubbleData data, _) =>
                5, // Keep all bubbles centered vertically
            sizeValueMapper: (OSIBubbleData data, _) => data.size,

            // Visual Styling
            minimumRadius: 10,
            maximumRadius: 40,
            gradient: LinearGradient(
              colors: [
                Colors.cyanAccent.withOpacity(0.6),
                Colors.blueAccent.withOpacity(0.6),
              ],
            ),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              builder:
                  (
                    dynamic data,
                    dynamic point,
                    dynamic series,
                    int pointIndex,
                    int seriesIndex,
                  ) {
                    return Text(data.protocol);
                  },
            ),
          ),
        ],
      ),
    );
    ;
  }

  Widget _buildLayerRow(
    String key,
    String name,
    Map<String, dynamic> layerData,
  ) {
    int count = layerData['count'];
    List dataList = layerData['data'];

    // Group protocols in this layer to count them (e.g., how many TCP vs UDP)
    Map<String, int> protocolCounts = {};
    for (var item in dataList) {
      String summary = item['summary'].toString().split(
        ' ',
      )[0]; // Get 'TCP' from 'TCP (Port: 80)'
      protocolCounts[summary] = (protocolCounts[summary] ?? 0) + 1;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: count > 0 ? Colors.cyan.withOpacity(0.5) : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(
              "Layer $key: $name",
              style: TextStyle(
                color: count > 0 ? Colors.cyanAccent : Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: protocolCounts.entries.map((entry) {
                return _buildProtocolCircle(entry.key, entry.value);
              }).toList(),
            ),
          ),
          if (count == 0)
            Text(
              "No Data",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildProtocolCircle(String name, int count) {
    return Tooltip(
      message: "$name: $count packets",
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.cyanAccent.withOpacity(0.8),
              Colors.blueAccent.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          name.substring(0, 1), // Shows first letter, e.g., 'T' for TCP
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class SummaryWidget extends StatefulWidget {
  final Map<String, dynamic> pcapData;
  const SummaryWidget({super.key, required this.pcapData});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  String data = '';
  bool isDataView = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        PcapText("Summary Analysis", fontSize: 18, isBold: true),
        SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: height(context) - 220,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          data =
                              "Packet No: ${index + 1}\n\n\t\t${(widget.pcapData['packet_details'][index]).toString().substring(1, (widget.pcapData['packet_details'][index]).toString().length - 1).replaceAll(", ", "\n\t\t").replaceAll("{", "\n{\n\t\t").replaceAll("}", "\n}")}";
                          isDataView = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PcapText(
                          widget.pcapData['packet_summaries'][index],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.pcapData['packet_summaries'].length,
              ),
            ),
            Visibility(
              visible: isDataView,
              child: Container(
                width: 250,
                height: 300,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: PcapText(data, fontSize: 12),
                ),
              ),
            ),
            Visibility(
              visible: isDataView,
              child: Align(
                alignment: Alignment.centerRight,
                child: PcapIconButton(
                  icon: Icons.close,
                  onPressed: () {
                    setState(() {
                      isDataView = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget protocolWidget(BuildContext context, Map<String, dynamic> protocolData) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      PcapText("Protocol Analysis", fontSize: 18, isBold: true),
      SizedBox(height: 8),
      Expanded(
        child: SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final protocol = protocolData['protocols'][index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PcapText(protocol['protocol'], fontSize: 12),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.white54,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: protocolData['protocols'].length,
          ),
        ),
      ),
    ],
  );
}

Widget protocolChartWidget(
  BuildContext context,
  Map<String, dynamic> protocolData,
) {
  final List<ProtocolData> data = (protocolData['protocols'] as List)
      .map(
        (item) =>
            ProtocolData(item['protocol'] as String, item['count'] as int),
      )
      .toList();

  return Container(
    padding: EdgeInsets.all(2),
    child: SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.scroll,
        textStyle: GoogleFonts.spaceGrotesk(
          textStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        textStyle: GoogleFonts.spaceGrotesk(
          textStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      series: <PieSeries<ProtocolData, String>>[
        PieSeries<ProtocolData, String>(
          dataSource: data,
          xValueMapper: (ProtocolData d, _) => d.protocol,
          yValueMapper: (ProtocolData d, _) => d.count,
          explode: true, // Pops the slice out when tapped
          explodeIndex: 0,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
            // // Moves labels outside the pie with lines to prevent clutter
            // labelPosition: ChartDataLabelPosition.outside,
            // connectorLineSettings: ConnectorLineSettings(
            //   type: ConnectorType.curve,
            //   color: Colors.white54,
            // ),
            // textStyle: GoogleFonts.spaceGrotesk(
            //   textStyle: TextStyle(color: Colors.white, fontSize: 12),
            // ),
          ),
          enableTooltip: true,
        ),
      ],
    ),
  );
}
