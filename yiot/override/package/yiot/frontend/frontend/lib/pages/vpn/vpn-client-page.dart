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
import 'package:yiot_portal/components/ui/yiot-title.dart';
import 'package:yiot_portal/components/ui/yiot-primary-button.dart';
import 'package:yiot_portal/components/ui/yiot-secondary-button.dart';

import 'package:yiot_portal/pages/vpn/yiot-wg-add-dialogue.dart';
import 'package:yiot_portal/pages/vpn/yiot-wg-remove-dialogue.dart';

import 'package:yiot_portal/services/helpers.dart';

import 'package:webviewx/webviewx.dart';

// -----------------------------------------------------------------------------
class VpnClientPage extends StatefulWidget {
  VpnClientPage({Key? key}) : super(key: key);

  @override
  _VpnClientPageState createState() => _VpnClientPageState();
}

// -----------------------------------------------------------------------------
class _VpnClientPageState extends State<VpnClientPage> {
  bool _disableWebView = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
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
              setState(() {
                _disableWebView = true;
              });
              await YIoTWgAddDialogue.show(context);
              setState(() {
                _disableWebView = false;
              });
            },
          ),
          SizedBox(
            width: 30,
          ),
          YIoTSecondaryButton(
            text: "Remove",
            onPressed: () async {
              setState(() {
                _disableWebView = true;
              });
              await YIoTWgRemoveDialogue.show(context);
              setState(() {
                _disableWebView = false;
              });
            },
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      // Add WebView component
      WebViewX(
        ignoreAllGestures: !_disableWebView,
        width: 1024,
        height: screenSize.height - 200,
        initialContent: YIoTServiceHelpers.wgClientsURL(),
        initialSourceType: SourceType.url,
      ),
    ]);
  }
}

// -----------------------------------------------------------------------------
