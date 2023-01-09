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
import 'package:google_fonts/google_fonts.dart';

import '../utils/responsive-layout.dart';

// -----------------------------------------------------------------------------

class YIoTBigButtonWidget extends StatefulWidget {
  final String imageName;
  final String text;
  final VoidCallback? action;
  double? margin;

  YIoTBigButtonWidget(
      {required this.imageName,
      required this.text,
      required this.action,
      this.margin,
      Key? key})
      : super(key: key) {
    if (margin == null) {
      margin = 0.0;
    }
  }

  @override
  State<YIoTBigButtonWidget> createState() => _YIoTBigButtonWidgetState(
        imageName: imageName,
        text: text,
        action: action,
        margin: margin!,
      );
}

class _YIoTBigButtonWidgetState extends State<YIoTBigButtonWidget> {
  static const _borderRadius = 20.0;
  final String imageName;
  final String text;
  final VoidCallback? action;
  final double margin;

  _YIoTBigButtonWidgetState(
      {required this.imageName,
      required this.text,
      required this.action,
      required this.margin});

  @override
  Widget build(BuildContext context) {
    var fontSz = ResponsiveLayout.fixFontSz(context, 25);
    var buttonSz = ResponsiveLayout.fixGeometrySz(context, 128);
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: action,
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
              borderRadius:
                  BorderRadius.circular(_borderRadius), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(buttonSz - margin), // Image radius
                child: Image.asset(imageName, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.arvo(
            fontSize: fontSz,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
