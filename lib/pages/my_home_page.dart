import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_button.dart';
import 'package:pcap_vision/widget/pcap_input.dart';
import 'package:pcap_vision/widget/pcap_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pcap_vision/widget/pcap_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController hostController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pathController = TextEditingController();
  String selectedInterface = "Wi-Fi";
  List<String> interface = ['Ethernet', 'Wi-Fi', 'Loopback', 'Bluetooth'];
  bool showCaptureInput = false, showInterfaceSelection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: pcapAppBar(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height(context) * 0.3,
                width: width(context),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      PcapText(
                        "Welcome to Pcap Vision",
                        fontSize: 60,
                        color: Theme.of(context).colorScheme.primary,
                        isBold: true,
                      ),
                      SizedBox(height: 24),
                      PcapText(
                        "Your ultimate network analysis tool",
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: width(context),
                  child: Row(
                    mainAxisAlignment: .spaceEvenly,
                    children: [
                      // Upload Area
                      Container(
                        width: 600,
                        height: 600,
                        margin: EdgeInsets.only(bottom: 24),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PcapText(
                              "Get Started",
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.primary,
                              isBold: true,
                            ),
                            PcapText(
                              "Import your pcap files and start analyzing your network traffic with Pcap vision.",
                              fontSize: 14,
                            ),
                            SizedBox(height: 24),
                            pcapUploadArea(context),
                          ],
                        ),
                      ),
                      // Live capture Area
                      Container(
                        width: 600,
                        height: 600,
                        margin: EdgeInsets.only(bottom: 24),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PcapText(
                              "Live Capture",
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.primary,
                              isBold: true,
                            ),
                            PcapText(
                              "Capture and analyze packets in real-time from your network interfaces.",
                              fontSize: 14,
                            ),
                            Spacer(),
                            pcapCaptureArea(
                              context,
                              hostController,
                              userController,
                            ),
                            PcapButton(
                              text: "Next",
                              onPressed: () {
                                setState(() {
                                  showCaptureInput = true;
                                  showInterfaceSelection = false;
                                });
                              },
                              icon: Icons.arrow_forward,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: showCaptureInput,
            child: Container(
              height: height(context),
              width: width(context),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  Container(
                    width: 600,
                    height: 600,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PcapText(
                          "Live Capture",
                          fontSize: 36,
                          color: Theme.of(context).colorScheme.primary,
                          isBold: true,
                        ),
                        PcapText(
                          "Capture and analyze packets in real-time from your network interfaces.",
                          fontSize: 14,
                        ),
                        SizedBox(height: 24),
                        PcapInput(
                          label: 'Host',
                          hintText: 'Host Address',
                          isRequired: true,
                          controller: hostController,
                          icon: Icons.computer,
                        ),
                        SizedBox(height: 14),
                        PcapInput(
                          label: 'User',
                          hintText: 'User Name',
                          isRequired: true,
                          controller: userController,
                          icon: Icons.person,
                        ),
                        SizedBox(height: 14),
                        PcapInput(
                          label: 'Password',
                          hintText: 'Password',
                          isRequired: true,
                          controller: passwordController,
                          icon: Icons.lock,
                        ),
                        SizedBox(height: 14),
                        PcapInput(
                          label: 'Path',
                          hintText: 'Path to Wireshark',
                          isRequired: true,
                          controller: pathController,
                          icon: Icons.folder,
                        ),
                        SizedBox(height: 4),
                        PcapTextButton(onPressed: () {}, text: "Get path"),
                        SizedBox(height: 24),
                        PcapButton(
                          text: "Next",
                          onPressed: () {
                            setState(() {
                              showCaptureInput = true;
                              showInterfaceSelection = true;
                            });
                          },
                          icon: Icons.arrow_forward,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showInterfaceSelection,
            child: Container(
              height: 222,
              width: 348,
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PcapText("Select Interface", fontSize: 14),
                  SizedBox(height: 24),
                  // Example: Selecting a Network Interface for your capture
                  DropdownMenu<String>(
                    initialSelection: "Ethernet",
                    label: const Text("Select Interface"),
                    width: 300,
                    textStyle: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),

                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      fillColor: Color(
                        0xff1E293B,
                      ), // Matches your sidebar color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Color(0xff137FEC),
                          width: 2,
                        ),
                      ),
                    ),
                    onSelected: (String? value) {
                      // This is where you get the value selected by the user
                      setState(() {
                        selectedInterface = value!;
                      });
                      print("Selected Interface: $selectedInterface");
                    },
                    dropdownMenuEntries: interface
                        .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                  SizedBox(height: 24),
                  PcapButton(
                    text: "Start Capture",
                    onPressed: () {},
                    icon: Icons.search,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: PcapIconButton(
                onPressed: () {
                  setState(() {
                    showCaptureInput = false;
                    showInterfaceSelection = false;
                  });
                },
                icon: Icons.close,
              ),
            ),
          ),
        ],
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
