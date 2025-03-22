import 'package:flutter/material.dart';
import 'package:touch_sender/util/logger.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    logBuildAction();
    return const Column(
      spacing: 20,
      children: [Text('Help Screen'), Text('Help Screen')],
    );
  }
}
