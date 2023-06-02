import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Reminder extends StatelessWidget {
  Reminder({super.key});

  final TextEditingController jamcontroller = TextEditingController();
  final TextEditingController menitcontroller = TextEditingController();

  void notif() async {
    String timenotif =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'bacic_channel',
          title: 'Add Note',
          body: 'Dont forget to add your note',
        ),
        schedule: NotificationInterval(timeZone: timenotif, repeats: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: () {
                notif();
              },
              child: const Text('Show Notif')),
          ElevatedButton(onPressed: () {}, child: const Text('alarm')),
        ],
      )),
    );
  }
}
