import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Page/Catatan/modelnote.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Cloud extends StatefulWidget {
  const Cloud({super.key});

  @override
  State<Cloud> createState() => _CloudState();
}

class _CloudState extends State<Cloud> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<FirebaseCloud>>(
      stream: readUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Text(
            'No Data Found',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ));
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return ListView(
            children: user.map(buildUser).toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }

  Stream<List<FirebaseCloud>> readUser() => FirebaseFirestore.instance
      .collection("${FirebaseAuth.instance.currentUser?.email}")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FirebaseCloud.fromJson(doc.data()))
          .toList());

  Widget buildUser(FirebaseCloud user) => Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 217, 97, 76)),
        child: Center(
          child: ListTile(
            title: Text(
              'Title : ${user.title}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              "Description : ${user.description}",
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
                onPressed: () {
                  final docUser = FirebaseFirestore.instance
                      .collection("${FirebaseAuth.instance.currentUser?.email}")
                      .doc(user.title);
                  docUser.delete();
                },
                icon: const Icon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.white,
                  size: 20,
                )),
          ),
        ),
      ));
}
