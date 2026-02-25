import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PcapInput extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final TextEditingController controller;
  final IconData? icon;
  const PcapInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.isRequired,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.spaceGrotesk(
                color: Colors.grey.shade400,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              suffixIcon: icon != null
                  ? Icon(icon, color: Colors.white)
                  : Icon(Icons.input, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
