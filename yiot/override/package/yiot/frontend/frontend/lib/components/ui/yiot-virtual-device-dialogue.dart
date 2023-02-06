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
import 'package:rflutter_alert/rflutter_alert.dart';

// -----------------------------------------------------------------------------

class YIoTVDevDialogue {
  static Future<String> show(BuildContext context) async {
    var _type = "";

    await Alert(
        context: context,
        title: "Create Virtual Device",
        content: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            SizedBox(
              width: 180,
              height: 40,
              child: TextButton.icon(
                onPressed: () {
                  _type = "lock";
                  Navigator.pop(context);
                },
                icon: Icon(Icons.lock, size: 25),
                label: Text("Door lock"),
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.only(left: 30),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 180,
              height: 40,
              child: TextButton.icon(
                onPressed: () {
                  _type = "lamp";
                  Navigator.pop(context);
                },
                icon: Icon(Icons.lightbulb, size: 25),
                label: Text("Lamp"),
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.only(left: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
        buttons: []).show();
      return _type;
  }
}

// -----------------------------------------------------------------------------
