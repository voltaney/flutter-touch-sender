import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return const Center(child: CircularProgressIndicator());
  }
}
