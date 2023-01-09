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

import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../widgets/big-button.dart';
import '../utils/responsive-layout.dart';
import 'package:google_fonts/google_fonts.dart';

// -----------------------------------------------------------------------------
class YIoTLandingPage extends StatefulWidget {
  @override
  _YIoTLandingPageState createState() {
    return new _YIoTLandingPageState();
  }
}

// -----------------------------------------------------------------------------
class _YIoTLandingPageState extends State<YIoTLandingPage> {
  static const _spacer = 30.0;
  static const _imageMargin = 20.0;

  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var szTotal = MediaQuery.of(context).size.height - 120;
    var szImages = szTotal * 3 / 4;
    var szComments = szTotal * 1 / 4;

    var fontSz = ResponsiveLayout.fixFontSz(context, 36.0);

    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: szComments,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      "YIoT helps easily create electronics and share your solutions with others",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.arvo(
                        fontSize: fontSz,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: _spacer,
                runSpacing: _spacer,
                alignment: WrapAlignment.center,
                children: [
                  YIoTBigButtonWidget(
                    imageName: 'landing/presentation.png',
                    text: 'Presentation',
                    action: () {
                      Navigator.of(context).pushNamed('/presentation');
                    },
                  ),
                  YIoTBigButtonWidget(
                    imageName: 'landing/device-example.png',
                    text: 'Device example',
                    action: () {
                      html.window.open(
                          'https://cdn.yiot.dev/docs/devices/cv-2se.pdf',
                          'example');
                    },
                  ),
                  YIoTBigButtonWidget(
                    imageName: 'landing/portal.png',
                    text: 'YIoT Portal',
                    action: () {
                      html.window.open('https://portal.yiot.dev/', 'portal');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
