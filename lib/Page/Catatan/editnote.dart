import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modelnote.dart';
import 'addnote.dart';
import 'database.dart';
import 'package:flutter_application_1/Page/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Page/Pengaturan/login.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;
  final Note? note;
  const NoteDetailPage({
    Key? key,
    required this.noteId,
    this.note,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  Color warnasatu = const Color.fromARGB(255, 248, 238, 226);
  Color warnadua = const Color.fromARGB(255, 217, 97, 76);
  late Note note;
  bool isLoading = false;
  late String title;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  Widget menu(String judul, Icon ikon) {
    return ListTile(
      onTap: () {
        rute(judul);
      },
      title: Text(judul,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold)),
      leading: ikon,
      iconColor: Colors.black,
    );
  }

  Future<void> rute(judul) async {
    if (judul == 'Edit') {
      if (isLoading) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditNotePage(note: note),
      ));
      refreshNote();
    } else if (judul == 'Import') {
      if (user?.email != null) {
        final docUser =
            FirebaseFirestore.instance.collection("${FirebaseAuth.instance.currentUser?.email}").doc(note.title);
        final user =
            FirebaseCloud(title: note.title, description: note.description);
        final json = user.toJson();
        await docUser.set(json);
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
                  title: Text(
                    'Data Import Successful',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('Please login before import data',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleLogin();
                            },
                            child: const Text('Login')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                      ],
                    ),
                  ));
            });
      }
    } else {
      await NotesDatabase.instance.delete(widget.noteId);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Edit Note',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          centerTitle: true,
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: menu('Edit',
                              const Icon(FontAwesomeIcons.penToSquare))),
                      PopupMenuItem(
                          child: menu('Import',
                              const Icon(FontAwesomeIcons.fileImport))),
                      PopupMenuItem(
                          child: menu(
                              'Delete', const Icon(FontAwesomeIcons.trash))),
                    ])
          ],
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),
                    Text(
                      note.description,
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
      );
}
