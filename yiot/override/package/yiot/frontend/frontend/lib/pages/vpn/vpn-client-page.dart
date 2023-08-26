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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yiot_portal/components/ui/yiot-title.dart';
import 'package:yiot_portal/components/ui/yiot-primary-button.dart';
import 'package:yiot_portal/components/ui/yiot-settings-element.dart';
import 'package:yiot_portal/components/ui/yiot-link-button.dart';
import 'package:yiot_portal/components/ui/yiot-progress-dialog.dart';

import 'package:yiot_portal/pages/vpn/yiot-wg-add-dialogue.dart';
import 'package:yiot_portal/pages/vpn/yiot-wg-remove-dialogue.dart';

import 'package:yiot_portal/controllers/yiot-vpn-client-controller.dart';
import 'package:yiot_portal/model/wireguard-status-model.dart';

import 'package:google_fonts/google_fonts.dart';

// -----------------------------------------------------------------------------
class VpnClientPage extends StatefulWidget {
  VpnClientPage({Key? key}) : super(key: key);

  @override
  _VpnClientPageState createState() => _VpnClientPageState();
}

// -----------------------------------------------------------------------------
class _VpnClientPageState extends State<VpnClientPage> {
  var wgInfo = <WgStatusModel>[];

  @override
  _VpnClientPageState() : super() {
    refresh();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      refresh();
    });
  }

  void refresh() {
    YIoTVpnClientController.get().then((info) {
      try {
        setState(() {
          wgInfo = info;
        });
      } catch(_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // -----------------------------------------------------------------------
      //  Title
      //
      YIoTTitle(title: 'VPN Clients'),
      Divider(
        color: Colors.black,
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          YIoTPrimaryButton(
            text: "Add",
            onPressed: () async {
              YIoTWgAddDialogue.show(context).then((file) {
                if (file.size > 0 && file.data != null) {
                  YIoTVpnClientController.apply(file.name, file.data!).then((success) {
                    if (!success) {
                      print(">>> Show Error message");
                    } else {
                      Future.delayed(const Duration(milliseconds: 5000), () {
                        DialogBuilder(context).hideOpenDialog();
                      });
                      DialogBuilder(context).showLoadingIndicator('Adding WireGuard client');
                    }
                  });
                }
              });
            },
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for(var item in wgInfo )
            Center(
              child: YIoTSettingsElement(
                name: item.name.replaceFirst("wg_", ""),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                    ),
                    Text ("Endpoint   : ${item.endpoint}", style: GoogleFonts.robotoMono()),
                    Text ("Public key : ${item.clientPublicKey}", style: GoogleFonts.robotoMono()),
                    Text ("Allowed IPs: ${item.allowedIPs}", style: GoogleFonts.robotoMono()),
                    Text ("Tx         : ${item.tx}", style: GoogleFonts.robotoMono()),
                    Text ("Rx         : ${item.rx}", style: GoogleFonts.robotoMono()),
                  ],
                ),
                actions: <Widget>[
                  YIoTLinkButton(
                    text: 'Remove',
                    color: Colors.red,
                    onPressed: () {
                      YIoTWgRemoveDialogue.show(context).then((needRemove) {
                        if (needRemove) {
                          YIoTVpnClientController.remove(item.name).then((success) {
                            if (!success) {
                              print(">>> Show Error message");
                            } else {
                              Future.delayed(const Duration(milliseconds: 5000), () {
                                DialogBuilder(context).hideOpenDialog();
                              });
                              DialogBuilder(context).showLoadingIndicator('Removing WireGuard client');
                            }
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ]);
  }
}

// -----------------------------------------------------------------------------
