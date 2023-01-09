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
import './button-primary.dart';
import './button-secondary.dart';
import '../utils/responsive-layout.dart';

// -----------------------------------------------------------------------------
class YIoTSpacerWidget extends StatelessWidget {
  late final double width;
  late final double height;

  YIoTSpacerWidget({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    var btnWidth = width * 0.5;

    var elements = <Widget>[];

    elements.add(YIoTPrimaryButton(
      text: "Device Example",
      width: btnWidth,
      onPressed: () {
        html.window.open('https://cdn.yiot.dev/docs/devices/cv-2se.pdf', 'example');
      },
    ));

    elements.add(YIoTSecondaryButton(
      text: "GitHub",
      width: btnWidth,
      onPressed: () {
        html.window.open('https://github.com/YIoT-team', 'github');
      },
    ));

    if (ResponsiveLayout.isLargeScreen(context)) {

      elements.add(YIoTPrimaryButton(
        text: "YouTube",
        width: btnWidth,
        onPressed: () {
          html.window.open('https://www.youtube.com/channel/UCT-wn_OWfhQj7HNjHrSRLDg', 'youtube');
        },
      ));
      elements.add(YIoTSecondaryButton(
        text: "Discord",
        width: btnWidth,
        onPressed: () {
          html.window.open('https://discord.gg/Ehbc4A2b2b', 'discord');
        },
      ));
    }

    elements.add(YIoTPrimaryButton(
      text: "LinkedIn",
      width: btnWidth,
      onPressed: () {
        html.window.open('https://www.linkedin.com/company/yiot', 'linkedin');
      },
    ));

    elements.add(YIoTSecondaryButton(
      text: "Contact us",
      width: btnWidth,
      onPressed: () {
        html.window.open('mailto:support@yiot.dev', 'email');
      },
    ));

    return Column(children: <Widget>[
      SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(width: 2, color: Colors.white))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: elements,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

// -----------------------------------------------------------------------------
