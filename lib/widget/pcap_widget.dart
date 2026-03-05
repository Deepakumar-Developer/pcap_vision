import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pcap_vision/function/app_function.dart';
import 'package:pcap_vision/widget/pcap_button.dart';
import 'package:pcap_vision/widget/pcap_input.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

double height(BuildContext context) => MediaQuery.of(context).size.height;

double width(BuildContext context) => MediaQuery.of(context).size.width;

PreferredSizeWidget pcapAppBar() => AppBar(
  title: PcapText("Pcap Vision", fontSize: 20),
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
