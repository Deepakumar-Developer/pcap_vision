import 'package:flutter/material.dart';
import 'package:pcap_vision/widget/pcap_text.dart';

class PcapButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final double? width;

  const PcapButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.width,
  });

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
          width: widget.width,
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

class PcapIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  const PcapIconButton({super.key, this.onPressed, this.icon});

  @override
  State<PcapIconButton> createState() => _PcapIconButtonState();
}

class _PcapIconButtonState extends State<PcapIconButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon ?? Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}
