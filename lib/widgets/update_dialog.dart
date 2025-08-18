import 'package:flutter/material.dart';
import '../services/version_checker.dart';

class UpdateDialog extends StatelessWidget {
  final String latestVersion;
  final bool forceUpdate;

  const UpdateDialog({
    Key? key,
    required this.latestVersion,
    this.forceUpdate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Available'),
      content: Text(
          'A new version ($latestVersion) of Ilolo is available. Please update to get the latest features and improvements.'),
      actions: [
        if (!forceUpdate)
          TextButton(
            onPressed: () async {
              // Mark as dismissed so we don't show again for this version
              await VersionChecker.markUpdateDismissed(latestVersion);
              Navigator.of(context).pop();
            },
            child: const Text('Later'),
          ),
        TextButton(
          onPressed: () {
            VersionChecker.launchAppStore();
            if (forceUpdate) {
              // Exit app if update is mandatory
              // SystemNavigator.pop();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Update Now'),
        ),
      ],
    );
  }
}


