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

import 'package:yiot_portal/components/ui/yiot-dialog-button.dart';
import 'package:yiot_portal/components/ui/yiot-dropdown.dart';

// -----------------------------------------------------------------------------

class YIoTWgRemoveDialogue {
  static Future<String> show(BuildContext context) async {
    var _type = "";

    await Alert(
        context: context,
        title: "Remove WireGuard connection",
        content: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: YIoTDropDown(
                items: [
                  'wg0',
                  'local-wg',
                  'yiot-cloud'
                ],
                onChanged: (index) {
                  print(">>> remove WireGuard connection: ${index}");
                },
              ),
            ),
          ],
        ),
        buttons: [
          YIoTDialogButton(
            context: context,
            title: "Ok",
            color: Colors.redAccent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          YIoTDialogButton(
            context: context,
            title: "Cancel",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]).show();
    return _type;
  }
}

// -----------------------------------------------------------------------------
