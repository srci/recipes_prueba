import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const InfoItem({Key? key, required this.icon, required this.value, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
      ],
    );
  }
}
