import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pcap_vision/function/server_function.dart';
import 'package:pcap_vision/pages/my_protocol_page.dart';
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
  automaticallyImplyLeading: false,
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
  Map<String, int> countProtocols(List data) {
    final map = <String, int>{};

    for (var item in data) {
      String protocol = item['summary'];

      map[protocol] = (map[protocol] ?? 0) + 1;
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    List<List<LayerData>> chartData = [];

    for (int i = 2; i <= 7; i++) {
      List layerProtocols =
          widget.osiLayerData['osi_mapping']['$i']['data'] ?? [];
      if ((widget.osiLayerData['osi_mapping']['$i']['count'] ?? []) == 0) {
        chartData.add([LayerData('No Frames', 1)]);
        continue;
      }
      Map<String, int> protocolCounts = countProtocols(layerProtocols);
      List<LayerData> layerData = protocolCounts.entries
          .map((entry) => LayerData(entry.key, entry.value))
          .toList();
      chartData.add(layerData);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        PcapText("OSI Layers", fontSize: 18, isBold: true),
        SizedBox(height: 8),
        SizedBox(
          height: height(context) - 220,
          width: .infinity,
          child: GridView.count(
            crossAxisCount: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              LayerCircleChart(
                layerName: "Layer 2 - Data Link",
                data: chartData[0],
              ),
              LayerCircleChart(
                layerName: "Layer 3 - Network",
                data: chartData[1],
              ),
              LayerCircleChart(
                layerName: "Layer 4 - Transport",
                data: chartData[2],
              ),
              LayerCircleChart(
                layerName: "Layer 5 - Session",
                data: chartData[3],
              ),
              LayerCircleChart(
                layerName: "Layer 6 - Presentation",
                data: chartData[4],
              ),
              LayerCircleChart(
                layerName: "Layer 7 - Application",
                data: chartData[5],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LayerCircleChart extends StatelessWidget {
  final String layerName;
  final List<LayerData> data;

  const LayerCircleChart({
    super.key,
    required this.layerName,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          PcapText(layerName, fontSize: 12, isBold: true),
          Expanded(
            child: SfCircularChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CircularSeries>[
                DoughnutSeries<LayerData, String>(
                  dataSource: data,
                  xValueMapper: (LayerData data, _) => data.protocol,
                  yValueMapper: (LayerData data, _) => data.count,
                  enableTooltip: true,
                ),
              ],
            ),
          ),
        ],
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

class ProtocolWidget extends StatefulWidget {
  final Map<String, dynamic> protocolData;
  final List<dynamic> data;
  const ProtocolWidget({
    super.key,
    required this.protocolData,
    required this.data,
  });

  @override
  State<ProtocolWidget> createState() => _ProtocolWidgetState();
}

class _ProtocolWidgetState extends State<ProtocolWidget> {
  bool isloader = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
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
                    final protocol = widget.protocolData['protocols'][index];
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            isloader = true;
                          });
                          Map<String, dynamic> protocolInfo = await PcapServer()
                              .getprotocolData(
                                protocol['protocol'],
                                widget.data,
                              );
                          setState(() {
                            isloader = false;
                            GetData().protocolInfo = protocolInfo;
                          });
                          if (protocolInfo.isEmpty) {
                            msg(
                              context,
                              "No data available for ${protocol['protocol']}",
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProtocolPage(
                                protocolName: protocol['protocol'],
                                protocolInfo: GetData().protocolInfo,
                                count: protocol['count'],
                              ),
                            ),
                          );
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
                  itemCount: widget.protocolData['protocols'].length,
                ),
              ),
            ),
          ],
        ),
        Visibility(visible: isloader, child: pcapLoader(context)),
      ],
    );
  }
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
