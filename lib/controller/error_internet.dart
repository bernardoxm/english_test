import 'package:app_settings/app_settings.dart';
import 'package:english_test/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkController {
  /// Checks internet connectivity and prompts the user to enable WiFi or Mobile Data.
  static Future<void> checkConnectionAndRetry({
    required BuildContext context,
    required VoidCallback onRetry,
  }) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Show a message if there's no internet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "No internet connection. Please enable WiFi or mobile data."),
        ),
      );

      // Open WiFi or Mobile Data settings
      AppSettings.openAppSettings(type: AppSettingsType.wifi);
    } else {
      // Close the error dialog and retry
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Replace with your main screen widget
          (route) => false, // Clears previous navigation history
        );
      }
    }
  }
}
