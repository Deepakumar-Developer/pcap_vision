// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pcap_vision/function/app_function.dart';
import 'package:pcap_vision/function/server_function.dart';
import 'package:pcap_vision/pages/my_result_page.dart';
import 'package:pcap_vision/widget/pcap_button.dart';
import 'package:pcap_vision/widget/pcap_input.dart';
import 'package:pcap_vision/widget/pcap_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pcap_vision/widget/pcap_widget.dart';
import 'package:desktop_drop/desktop_drop.dart';

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
  late int ifaceIndex = interface.indexOf("Wi-Fi") + 1;
  bool showCaptureInput = false,
      showInterfaceSelection = false,
      isLoader = false,
      isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: pcapAppBar(context),
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
                              textAlign: .left,
                            ),
                            SizedBox(height: 24),
                            DropTarget(
                              onDragDone: (detail) async {
                                setState(() => isLoader = true);
                                final file = detail.files.first;
                                final bytes = await file.readAsBytes();

                                List<dynamic> response = await processFile(
                                  file.name,
                                  bytes,
                                );
                                if (response.isEmpty) {
                                  msg(context, "Error in Fetching Analysis");
                                  setState(() => isLoader = false);
                                  return;
                                }
                                for (var res in response) {
                                  assignResponse(res['route'], res['data']);
                                }
                                setState(() => isLoader = false);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyResultPage(),
                                  ),
                                );
                              },
                              onDragEntered: (detail) =>
                                  setState(() => isDragging = true),
                              onDragExited: (detail) =>
                                  setState(() => isDragging = false),
                              child: Stack(
                                children: [
                                  PcapUploadArea(),
                                  Visibility(
                                    visible: isDragging,
                                    child: Container(
                                      height: 250,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                        PcapTextButton(
                          onPressed: () async {
                            if (hostController.text.isEmpty ||
                                userController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              msg(context, "Please fill remaining fields");
                              return;
                            }
                            setState(() {
                              isLoader = true;
                              pathController.text = "Fetching path...";
                            });
                            String path = await PcapServer().getPath(
                              hostController.text,
                              userController.text,
                              passwordController.text,
                            );
                            setState(() {
                              isLoader = false;
                              if (path.startsWith("404")) {
                                pathController.text = "";
                                msg(context, "Error in Finding Path");
                              } else {
                                pathController.text = path;
                              }
                            });
                          },
                          text: "Get path",
                        ),
                        SizedBox(height: 24),
                        PcapButton(
                          text: "Next",
                          onPressed: () async {
                            if (hostController.text.isEmpty ||
                                userController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                pathController.text.isEmpty) {
                              msg(context, "Please fill all fields");
                              return;
                            }
                            setState(() {
                              isLoader = true;
                            });
                            List<List<String>> iface = await PcapServer()
                                .getInterface(
                                  hostController.text,
                                  userController.text,
                                  passwordController.text,
                                  pathController.text,
                                );
                            setState(() {
                              isLoader = false;
                              if (iface.isNotEmpty &&
                                  !iface.first.first.startsWith("404")) {
                                interface = [];
                                for (var i in iface) {
                                  interface.add(i.last);
                                }
                                showCaptureInput = true;
                                showInterfaceSelection = true;
                              } else {
                                msg(context, "Error in Fetching Interfaces");
                              }
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
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color(0xff1E293B),
                      ),
                      surfaceTintColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      fillColor: Color(0xff1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Color(0xff137FEC),
                          width: 2,
                        ),
                      ),
                    ),
                    onSelected: (String? value) {
                      setState(() {
                        selectedInterface = value!;
                        ifaceIndex = interface.indexOf(selectedInterface) + 1;
                      });
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
                    onPressed: () async {
                      setState(() {
                        isLoader = true;
                      });
                      String outputFile = await PcapServer().getPCAP(
                        hostController.text,
                        userController.text,
                        passwordController.text,
                        pathController.text,
                        ifaceIndex.toString(),
                      );

                      if (outputFile.startsWith("404")) {
                        msg(context, "Error in Starting Capture");

                        setState(() => isLoader = false);
                        return;
                      } else {
                        msg(context, "Capture Completed: $outputFile");
                      }
                      await Future.delayed(Duration(seconds: 2));
                      msg(context, "Fetching Analysis Results...");
                      await Future.delayed(Duration(seconds: 2));

                      List<Map<String, dynamic>> response = await PcapServer()
                          .fetchPCAP(outputFile, 'path');
                      if (response.isEmpty) {
                        msg(context, "Error in Fetching Analysis");
                        setState(() => isLoader = false);
                        return;
                      }
                      for (var res in response) {
                        assignResponse(res['route'], res['data']);
                      }
                      setState(() => isLoader = false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyResultPage()),
                      );
                    },
                    icon: Icons.search,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showCaptureInput || showInterfaceSelection,
            child: Align(
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
          ),
          Visibility(visible: isLoader, child: pcapLoader(context)),
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

  void assignResponse(String route, Map<String, dynamic> responseBody) {
    switch (route) {
      case '':
        setState(() => GetData().pcapData = responseBody);
        break;
      case '/metadata':
        setState(() => GetData().metaData = responseBody);
        break;
      case '/ipAddress':
        setState(() => GetData().ipAddrData = responseBody);
        break;
      case '/macAddress':
        setState(() => GetData().macAddrData = responseBody);
        break;
      case '/get_protocols':
        setState(() => GetData().protocolData = responseBody);
        break;
      case '/get_osi':
        setState(() => GetData().osiLayerData = responseBody);
        break;
      default:
    }
  }
}
