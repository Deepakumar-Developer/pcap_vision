import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PcapText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final bool isBold;
  const PcapText(
    this.text, {
    super.key,
    required this.fontSize,
    this.color = Colors.white,
    this.isBold = false,
  });

  @override
  State<PcapText> createState() => _PcapTextState();
}

class _PcapTextState extends State<PcapText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.spaceGrotesk(
        textStyle: TextStyle(
          letterSpacing: 0.5,
          color: widget.color,
          fontSize: widget.fontSize,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
