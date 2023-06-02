import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Page/Pengaturan/cloud.dart';
import 'package:flutter_application_1/Page/Pengaturan/login.dart';
import 'package:flutter_application_1/Page/Pengaturan/reminder.dart';
import 'package:flutter_application_1/Page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'darkmode.dart';
import 'package:flutter_application_1/Page/Pengaturan/about.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_sizer/flutter_sizer.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  //switch value
  bool? reminder;
  bool? darkmode;

  //Warna
  Color warnasatu = const Color.fromARGB(255, 248, 238, 226);
  Color warnadua = const Color.fromARGB(255, 217, 97, 76);

  //email
  final user = FirebaseAuth.instance.currentUser;
  //iklan
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {},
        ),
        request: const AdRequest());
    _bannerAd.load();
  }

  @override
  void initState() {
    loadReminder();
    loadDarkMode();
    super.initState();
    //iklan
    _initBannerAd();
    //akun
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {}
    });
  }

  Widget menu(
    Icon ikon,
    String judul,
  ) {
    return Padding(
        padding: EdgeInsets.only(bottom: 3.h),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 9.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: warnasatu),
          child: Center(
            child: ListTile(
              onTap: () {
                rutesetting(judul);
              },
              leading: ikon,
              iconColor: Colors.black,
              title: Text(judul,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Slabo27')),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black,
              ),
            ),
          ),
        ));
  }

  Widget info(String email, String buttontext, Color txtcolor) {
    return Container(
      height: 10.5.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
          color: warnadua, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 1.9.h, horizontal: 1.w),
              child: Center(
                child: ListTile(
                  title: Text(
                    email,
                    style: TextStyle(color: txtcolor, fontFamily: 'Slabo27'),
                  ),
                  trailing: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: warnasatu),
                      onPressed: () {
                        ruteakun();
                      },
                      child: Text(
                        buttontext,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> rutesetting(String judul) async {
    if (judul == 'Reminder') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Reminder()));
    } else if (judul == 'Cloud') {
      if (user?.email != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Cloud()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
                  title: Text(
                    'Please login before use this feature',
                    style: TextStyle(
                        fontFamily: 'Slabo27', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ));
      }
    } else if (judul == 'About') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const About()));
    } else if (judul == "Support") {
      String email = Uri.encodeComponent("68pratama@gmail.com");
      String subject = Uri.encodeComponent("Hai I have Problem");
      String body = Uri.encodeComponent("Hi! I'm Your Kenanganku App User");
      Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
      if (await launchUrl(mail)) {
      } else {}
    }
  }

  void ruteakun() {
    if (user?.email != null) {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      provider.googleLogout();
      Navigator.pop(context);
    } else {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      provider.googleLogin();
    }
  }

  void notif() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'bacic_channel',
          title: 'Add Note',
          body: 'Dont forget to add your note',
        ),
        schedule: NotificationCalendar(hour: 19, minute: 0));
  }

  loadReminder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      reminder = preferences.getBool('switchval');
    });
  }

  loadDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      darkmode = preferences.getBool('switchval2');
    });
  }

  @override
  Widget build(BuildContext context) {
    saveReminder() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('switchval', reminder!);
    }

    saveDarkMode() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('switchval2', darkmode!);
    }

    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            theme: theme.getTheme(),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('Setting',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                    },
                    icon: const Icon(FontAwesomeIcons.arrowLeft)),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        child: user?.email != null
                            ? info("${user?.email}", 'Log Out', Colors.black)
                            : info('Email', 'Login',
                                const Color.fromARGB(100, 0, 0, 0))),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: warnadua),
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  height: 9.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: warnasatu),
                                  child: Center(
                                      child: SwitchListTile(
                                          activeColor: warnadua,
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor: Colors.black,
                                          activeTrackColor: Colors.black,
                                          title: const Text('Reminder',
                                              style: TextStyle(
                                                  fontFamily: 'Slabo27',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          subtitle: const Text(
                                              'Reminder will be set at 7 PM',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10)),
                                          value: reminder != null
                                              ? reminder!
                                              : false,
                                          onChanged: (bool val) {
                                            setState(() {
                                              reminder = val;
                                              if (val == true) {
                                                notif();
                                              } else {}
                                            });
                                            saveReminder();
                                          })))),
                          Padding(
                              padding: EdgeInsets.only(bottom: 3.h),
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  height: 9.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: warnasatu),
                                  child: Center(
                                      child: SwitchListTile(
                                          activeColor: warnadua,
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor: Colors.black,
                                          activeTrackColor: Colors.black,
                                          title: const Text('Dark Mode',
                                              style: TextStyle(
                                                  fontFamily: 'Slabo27',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          value: darkmode != null
                                              ? darkmode!
                                              : false,
                                          onChanged: (bool val2) {
                                            setState(() {
                                              darkmode = val2;
                                              if (val2 == true) {
                                                theme.setDarkMode();
                                              } else {
                                                theme.setLightMode();
                                              }
                                            });
                                            saveDarkMode();
                                          })))),
                          menu(
                              const Icon(FontAwesomeIcons.boxArchive), 'Cloud'),
                          menu(const Icon(FontAwesomeIcons.headset), 'Support'),
                          menu(const Icon(Icons.perm_device_info_sharp),
                              'About'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: _isAdLoaded
                  ? SizedBox(
                      height: _bannerAd.size.height.toDouble(),
                      width: _bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    )
                  : Container(),
            )));
  }
}

class AdmobService {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2873255698671213/3762764385';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
