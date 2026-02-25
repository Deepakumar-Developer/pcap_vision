import 'package:flutter/material.dart';
import 'package:pcap_vision/pages/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff137FEC),
          primary: Color(0xff137FEC),
          secondary: Color(0xff1E293B),
          tertiary: Color(0xff94A3B8),
          surface: Color(0xff101922),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
