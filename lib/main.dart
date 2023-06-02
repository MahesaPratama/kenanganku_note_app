import 'package:flutter/material.dart';
import 'package:flutter_application_1/Page/Pengaturan/login.dart';
import 'package:flutter_application_1/Page/splashscreen.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Page/Pengaturan/darkmode.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'bacic_channel',
            channelName: 'basic notif',
            channelDescription: 'notif test',
            ledColor: Colors.amber,
            defaultColor: Colors.black,
            enableLights: true)
      ],
      debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: FlutterSizer(builder: (context, orientation, screenType) {
        //atur theme
        return Consumer<ThemeNotifier>(
          builder: (context, theme, _) => MaterialApp(
            theme: theme.getTheme(),
            debugShowCheckedModeBanner: false,
            title: 'Kenanganku',
            home: const SplashScreen(),
          ),
        );
      }));
}
