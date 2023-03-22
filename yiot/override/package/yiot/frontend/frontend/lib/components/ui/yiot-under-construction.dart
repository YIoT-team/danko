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
import 'package:yiot_portal/theme/theme.dart';

// -----------------------------------------------------------------------------
class YIoTUnderConstruction extends StatelessWidget {
  late final String text;
  late final bool showImage;

  YIoTUnderConstruction({required this.text, required this.showImage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    var fontSz = showImage ? YIoTTheme.fontH1(context) : YIoTTheme.fontH2(context);
    double spaceSz = showImage ? 40 : 20;

    var components = <Widget>[
      Center(
        child: Text(
          'Functionality is under development !',
          style: TextStyle(
            fontSize: fontSz,
            color: Colors.red,
          ),
        ),
      ),
      SizedBox(
        height: spaceSz,
      ),
      Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSz,
            color: Colors.black,
          ),
        ),
      ),
      SizedBox(
        height: spaceSz,
      ),
    ];

    if (showImage) {
      components.add(
        Container(
          margin: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Image border
            child: SizedBox.fromSize(
              size: Size.fromRadius(250), // Image radius
              child: Image.asset('images/under-construction.jpg',
                  fit: BoxFit.cover),
            ),
          ),
        ),
      );

      components.add(SizedBox(height: 40));
    }

    return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: components,
        ));
  }
}

// -----------------------------------------------------------------------------
