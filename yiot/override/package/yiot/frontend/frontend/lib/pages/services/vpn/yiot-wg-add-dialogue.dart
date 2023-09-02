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
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yiot_portal/components/ui/yiot-dialog-button.dart';
import 'package:yiot_portal/components/ui/yiot-file-picker.dart';
import 'package:yiot_portal/services/helpers.dart';

// -----------------------------------------------------------------------------

class WireGuardConfig {
  late final String name;
  late final int size;
  late final List<int>? data;
  WireGuardConfig({required this.name, required this.size, required this.data});
}

class YIoTWgAddDialogue {
  static Future<WireGuardConfig> show(BuildContext context) async {
    var _res = WireGuardConfig(
      name: "",
      size: 0,
      data: null,
    );

    await Alert(
        context: context,
        title: "Add WireGuard connection",
        content: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: YIoTFilePicker(
                welcomeText: 'Choose VPN configuration file',
                extensions: ['conf'],
                onFileSelected: (name, size, data) {
                  _res = WireGuardConfig(
                      name: name,
                      size: size,
                      data: data,
                  );
                },
              ),
            ),
          ],
        ),
        buttons: [
          YIoTDialogButton(
            context: context,
            title: "Ok",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          YIoTDialogButton(
            context: context,
            title: "Help",
            color: Colors.grey,
            onPressed: () {
              html.window.open(YIoTServiceHelpers.wgAddHelpURL(), "wg-add-help");
            },
          ),
        ]).show();
    return _res;
  }
}

// -----------------------------------------------------------------------------
