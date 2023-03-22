//  ────────────────────────────────────────────────────────────
//                     ╔╗  ╔╗ ╔══╗      ╔════╗
//                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
//                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
//                      ╚╗╔╝   ║║  ║╔╗║   ║║
//                       ║║   ╔╣╠╗ ║╚╝║   ║║
//                       ╚╝   ╚══╝ ╚══╝   ╚╝
//    ╔╗╔═╗                    ╔╗                     ╔╗
//    ║║║╔╝                   ╔╝╚╗                    ║║
//    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
//    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
//    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
//    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
//                    ║║                         ║║
//                    ╚╝                         ╚╝
//
//    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
//  ────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:yiot_portal/theme/theme.dart';

typedef OnFileSelected = void Function(String name, int size, List<int>? data);

// -----------------------------------------------------------------------------
class YIoTFilePicker extends StatefulWidget {
  OnFileSelected onFileSelected;
  List<String> extensions;
  String welcomeText;
  _YIoTFilePickerState? state;

  YIoTFilePicker(
      {required this.welcomeText,
      required this.extensions,
      required this.onFileSelected});

  @override
  State<YIoTFilePicker> createState() {
    if (state == null) {
      state = new _YIoTFilePickerState(
          welcomeText: welcomeText,
          extensions: extensions,
          onFileSelected: onFileSelected);
    }
    return state!;
  }

  bool selected() {
    return state?.selected ?? false;
  }

  List<int>? fileData() {
    return state?.fileData;
  }
}

class _YIoTFilePickerState extends State<YIoTFilePicker> {
  OnFileSelected onFileSelected;
  List<String> extensions;
  String welcomeText;

  late TextEditingController _controller;
  List<int>? fileData;

  bool selected = false;

  _YIoTFilePickerState(
      {required this.welcomeText,
      required this.extensions,
      required this.onFileSelected}) {
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: welcomeText,
        suffixIcon: Icon(Icons.vpn_lock),
      ),
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: extensions,
        );

        if (result != null) {
          PlatformFile file = result.files.first;

          if (file.bytes != null) {
            setState(() {
              fileData = file.bytes;
              _controller.text = file.name;
              selected = true;
            });
            onFileSelected(file.name, file.size, file.bytes);
          }
        } else {
          // User stopped the picker
        }
      },
    );
  }
}

// -----------------------------------------------------------------------------
