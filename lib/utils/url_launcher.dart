import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

Future<void> _testLaunch() async {
  try {
    final Uri url = Uri.parse('https://youtu.be/csG7x8U0WxI');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    log('Error launching URL: $e');
    // Show error to user
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Could not open link: $e')),
    // );
  }
}