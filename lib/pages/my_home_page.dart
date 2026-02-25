import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: PcapText("Pcap Vision", fontSize: 20)),
      body: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Column()],
      ),
    );
  }
}
