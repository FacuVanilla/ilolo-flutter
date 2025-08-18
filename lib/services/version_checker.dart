import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionChecker {
  // App's Play Store URL
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.ilolo.app';

  // Hardcoded latest version - Update this manually when you release new versions
  static const String latestVersion =
      '1.3.7'; // Change this value when you release new versions

  // Set to true if you want to force users to update (no "Later" button)
  static const bool forceUpdate = false;

  // Check if an update is available
  static Future<bool> isUpdateAvailable() async {
    try {
      // Get current installed version
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      // Compare versions (using semantic versioning)
      return _isHigherVersion(latestVersion, currentVersion);
    } catch (e) {
      print('Error checking for updates: $e');
      return false;
    }
  }

  // Helper method to compare version strings
  static bool _isHigherVersion(String latestVersion, String currentVersion) {
    List<int> latest = latestVersion.split('.').map(int.parse).toList();
    List<int> current = currentVersion.split('.').map(int.parse).toList();

    // Pad versions to same length
    while (latest.length < current.length) latest.add(0);
    while (current.length < latest.length) current.add(0);

    // Compare version segments
    for (int i = 0; i < latest.length; i++) {
      if (latest[i] > current[i]) return true;
      if (latest[i] < current[i]) return false;
    }

    return false; // Versions are equal
  }

  // Launch the Play Store for update
  static Future<void> launchAppStore() async {
    final Uri url = Uri.parse(playStoreUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Check if user has dismissed this update
  static Future<bool> hasUserDismissedUpdate(String version) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dismissed_update_$version') ?? false;
  }

  // Mark update as dismissed by user
  static Future<void> markUpdateDismissed(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dismissed_update_$version', true);
  }

  // Get current app version
  static Future<String> getCurrentVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
