import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class About extends StatelessWidget {
  const About({super.key});

  final Color warnasatu = const Color.fromARGB(255, 248, 238, 226);
  final Color warnadua = const Color.fromARGB(255, 217, 97, 76);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: warnadua),
              child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                      'Kenanganku adalah aplikasi yang memungkinkan kamu untuk menyimpan dan mengelola catatan-catatan kenangan berharga dalam satu tempat yang aman dan mudah diakses. Aplikasi ini menyediakan berbagai fitur yang memudahkan kamu untuk mencatat momen-momen penting dalam hidupmu, sehingga kamu dapat mengingat kembali kenangan-kenangan yang tak terlupakan dengan mudah.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                      textAlign: TextAlign.center))),
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
              child: const Text(
                'Version 1.0',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    ));
  }
}
