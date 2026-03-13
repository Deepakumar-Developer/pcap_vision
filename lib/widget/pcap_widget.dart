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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'Packet vs Time Slot',
              textStyle: GoogleFonts.spaceGrotesk(
                textStyle: TextStyle(color: Colors.white70, fontSize: 14),
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
