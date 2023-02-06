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

class YIoTSettingsElement extends StatelessWidget {
  final String name;
  final Widget body;
  final List<Widget> actions;
  final bool centered;

  YIoTSettingsElement(
      {required this.name,
      required this.body,
      required this.actions,
      this.centered = false,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              name,
              style: TextStyle(
                  fontSize: YIoTTheme.fontH2(context),
                  fontWeight: FontWeight.bold),
              textAlign: this.centered ? TextAlign.right : TextAlign.left,
            ),
          ),
          Expanded(
            flex: this.centered ? 1 : 3,
            child: Center(
              child: body,
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: this.centered ? Alignment.centerLeft : Alignment.center,
              child: Column(
                children: actions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
