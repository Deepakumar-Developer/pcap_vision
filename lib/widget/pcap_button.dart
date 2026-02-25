import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

class PcapButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  const PcapButton({super.key, this.onPressed, required this.text, this.icon});

  @override
  State<PcapButton> createState() => _PcapButtonState();
}

class _PcapButtonState extends State<PcapButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon ?? Icons.add, color: Colors.white),
              const SizedBox(width: 8),
              PcapText(widget.text, fontSize: 16, isBold: true),
            ],
          ),
        ),
      ),
    );
  }
}

class PcapTextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  const PcapTextButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<PcapTextButton> createState() => _PcapTextButtonState();
}

class _PcapTextButtonState extends State<PcapTextButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: PcapText(widget.text, fontSize: 14),
      ),
    );
  }
}
