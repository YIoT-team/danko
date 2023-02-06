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

// -----------------------------------------------------------------------------

class YIoTBigDownloadButtonWidget extends StatefulWidget {
  final String imageName;
  final String downloadURL;
  double? margin;

  YIoTBigDownloadButtonWidget(
      {required this.imageName,
      required this.downloadURL,
      this.margin,
      Key? key})
      : super(key: key) {
    if (margin == null) {
      margin = 0.0;
    }
  }

  @override
  State<YIoTBigDownloadButtonWidget> createState() =>
      _YIoTBigDownloadButtonWidgetState(
        imageName: imageName,
        downloadURL: downloadURL,
        margin: margin!,
      );
}

class _YIoTBigDownloadButtonWidgetState
    extends State<YIoTBigDownloadButtonWidget> {
  static const _borderRadius = 20.0;
  final String imageName;
  final String downloadURL;
  final double margin;

  _YIoTBigDownloadButtonWidgetState(
      {required this.imageName, required this.downloadURL, required this.margin});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) return 20.0;
              return 5.0;
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  side: BorderSide(color: Colors.black)))),
      child: Container(
        margin: EdgeInsets.all(margin),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius), // Image border
          child: SizedBox.fromSize(
            size: Size.fromRadius(128 - margin), // Image radius
            child: Image.asset(imageName, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
