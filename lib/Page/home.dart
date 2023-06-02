import 'package:flutter/material.dart';
import 'package:flutter_application_1/Page/Pengaturan/setting.dart';
import 'package:flutter_application_1/Page/Catatan/modelnote.dart';
import 'package:flutter_application_1/Page/Catatan/database.dart';
import 'package:flutter_application_1/Page/Catatan/addnote.dart';
import 'package:flutter_application_1/Page/Catatan/editnote.dart';
import 'package:flutter_application_1/Page/Catatan/notecard.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    scale: 2,
                    image: AssetImage('assets/Image/background.png'),
                    alignment: Alignment.center)),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : buildNotes(),
          )),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEditNotePage()));
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 8.5.h,
        child: BottomAppBar(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconButton(
                  onPressed: null,
                  icon: Icon(
                    FontAwesomeIcons.houseUser,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Setting()));
                  },
                  icon: const Icon(
                    FontAwesomeIcons.gear,
                    color: Colors.white,
                    size: 30,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
