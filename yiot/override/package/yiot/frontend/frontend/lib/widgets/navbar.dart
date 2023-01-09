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
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'button-primary.dart';
import 'button-secondary.dart';
import '../utils/responsive-layout.dart';

// -----------------------------------------------------------------------------
class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var p = ResponsiveLayout.fixGeometrySz(context, 45);
    var imgSz = ResponsiveLayout.fixGeometrySz(context, 48);
    var tytleSz = ResponsiveLayout.fixFontSz(context, 30);

    var iconWidget = Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/');
          }, // Image tapped
          child: Image.asset(
            'yiot.png',
            width: imgSz,
          ),
        )
      ],
    );

    var discordWidget = YIoTSecondaryButton(
      text: "Discord",
      onPressed: () {
        html.window.open('https://discord.gg/Ehbc4A2b2b', 'discord');
      },
    );

    var portalWidget = YIoTPrimaryButton(
      text: "YIoT Portal",
      onPressed: () {
        html.window.open('https://portal.yiot.dev/', 'portal');
      },
    );

    var content = <Widget>[];

    if (ResponsiveLayout.isSmallScreen(context)) {
      content.add(iconWidget);

      content.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          discordWidget,
          SizedBox(
            width: 20,
          ),
          portalWidget,
        ],
      ));
    } else {
      content.add(Flexible(
        flex: 1,
        child: iconWidget,
      ));

      if (ModalRoute.of(context)?.settings.name == '/') {
        content.add(Flexible(
          flex: 1,
          child: Text(
            "Your IoT",
            textAlign: TextAlign.center,
            style: GoogleFonts.arvo(
              fontSize: tytleSz,
              color: Colors.white,
            ),
          ),
        ));
      }

      content.add(Flexible(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Spacer(),
            discordWidget,
            SizedBox(width: 20),
            portalWidget,
          ],
        ),
      ));
    }

    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: p, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: content,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
