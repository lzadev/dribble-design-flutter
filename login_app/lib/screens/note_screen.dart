import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();
    quill.QuillController _controller = quill.QuillController.basic();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 24,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              splashRadius: 24,
              icon: const Icon(
                Icons.save_outlined,
                size: 28,
              ),
              onPressed: () => {},
            ),
          ),
        ],
        toolbarHeight: 75.0,
        elevation: 0,
        title: const Text('Note'),
        backgroundColor: const Color.fromRGBO(110, 1, 239, 1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
            child: quill.QuillToolbar.basic(
              multiRowsDisplay: false,
              // toolbarSectionSpacing: 3,
              controller: _controller,
              // showUndo: false,
              // showRedo: false,
              showSearchButton: false,
              // toolbarIconAlignment: WrapAlignment.start,
              toolbarIconSize: 18.0,
              // showFontSize: false,
              showLink: false,
              iconTheme: const quill.QuillIconTheme(
                borderRadius: 12,
                iconSelectedFillColor: Color.fromRGBO(110, 1, 239, 1),
                iconSelectedColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: MouseRegion(
                cursor: SystemMouseCursors.text,
                child: quill.QuillEditor(
                  controller: _controller,
                  scrollController: ScrollController(),
                  scrollable: true,
                  autoFocus: false,
                  readOnly: false,
                  enableSelectionToolbar: isMobile(),
                  placeholder: 'Add your note',
                  focusNode: _focusNode,
                  expands: false,
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    left: 15.0,
                    right: 15.0,
                  ),

                  customStyles: quill.DefaultStyles(
                    sizeSmall: const TextStyle(fontSize: 14),
                    sizeLarge: const TextStyle(fontSize: 20),
                    sizeHuge: const TextStyle(fontSize: 26),
                  ),
                  // FlutterQuillEmbeds.builders(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromRGBO(110, 1, 239, 1),
      //   onPressed: () {
      //     var json = jsonEncode(
      //       _controller.document.toDelta().toJson(),
      //     );
      //     print(json);
      //   },
      //   child: const Icon(Icons.save_alt_outlined, color: Colors.white),
      // ),
      // body: Center(
      //   child: TextButton(
      //     onPressed: () => FirebaseAuth.instance.signOut(),
      //     child: const Text('SignOut'),
      //   ),
      // ),
    );
  }
}
