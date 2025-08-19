import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';  // Temporarily disabled
import 'package:ilolo/app/app_notifier.dart';
import 'package:ilolo/app/app_router.dart';
import 'package:ilolo/services/custom_auth_service.dart';  // Using custom authentication service
import 'package:ilolo/services/version_checker.dart';
import 'package:ilolo/utils/style.dart';
import 'package:ilolo/widgets/update_dialog.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await CustomAuthService().initialize();  // Initialize custom authentication service

  // MobileAds.instance.initialize();  // Temporarily disabled
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  dynamic router = await appRouter();
  runApp(MyApp(
    r: router,
  ));
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({required this.r, super.key});
  final dynamic r;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Check for updates after the app is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    final updateAvailable = await VersionChecker.isUpdateAvailable();

    if (updateAvailable) {
      final currentVersion = await VersionChecker.getCurrentVersion();

      // Check if user has already dismissed this update
      final hasDismissed = await VersionChecker.hasUserDismissedUpdate(
          VersionChecker.latestVersion);

      if (!hasDismissed) {
        // We need a valid BuildContext that's a descendant of MaterialApp
        // Use Future.delayed to ensure the widget tree is fully built
        Future.delayed(const Duration(seconds: 1), () {
          // Use the global key from your router to get a valid context
          final context = widget.r.routerDelegate.navigatorKey.currentContext;
          if (context != null) {
            showDialog(
              context: context,
              barrierDismissible: !VersionChecker.forceUpdate,
              builder: (context) => UpdateDialog(
                latestVersion: VersionChecker.latestVersion,
                forceUpdate: VersionChecker.forceUpdate,
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor:
          const Color.fromARGB(0, 0, 0, 0), // Set the status bar color
    ));
    const MaterialColor colorCustom = MaterialColor(0xff1895B0, mainColorRgb);
    return MultiProvider(
      providers: changeNotifierProvider,
      child: MaterialApp.router(
        title: 'Ilolo Market',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        darkTheme: ThemeData(brightness: Brightness.dark),
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: GoogleFonts.interTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          primarySwatch: colorCustom,
          primaryColor: colorCustom,
          focusColor: colorCustom,
          canvasColor: colorCustom,
          indicatorColor: colorCustom,
          useMaterial3: true,
          dialogBackgroundColor: Colors.white,
        ),
        routerConfig: widget.r,
      ),
    );
  }
}
