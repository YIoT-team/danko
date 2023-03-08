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

import 'package:webviewx/webviewx.dart';
//import 'package:easy_web_view/easy_web_view.dart';

// -----------------------------------------------------------------------------
class EthernetPage extends StatefulWidget {
  EthernetPage({Key? key}) : super(key: key);

  @override
  _EthernetPageState createState() => _EthernetPageState();
}

// -----------------------------------------------------------------------------
class _EthernetPageState extends State<EthernetPage> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      // -----------------------------------------------------------------------
      //  Title
      //
      YIoTTitle(title: 'Ethernet'),
      Divider(
        color: Colors.black,
      ),
//      SizedBox(
//        height: 20,
//      ),
      WebViewX(
        width: 10000,
        height: 10000,
        initialContent: "http://192.168.0.251/cgi-bin/luci/admin/services/ttyd",
        initialSourceType: SourceType.url,
        webSpecificParams: WebSpecificParams(
//          printDebugInfo: true,
          additionalSandboxOptions: const [
            'allow-downloads',
            'allow-forms',
            'allow-modals',
            'allow-orientation-lock',
            'allow-pointer-lock',
            'allow-popups',
            'allow-popups-to-escape-sandbox',
            'allow-presentation',
            'allow-same-origin',
             'allow-top-navigation',
//             'allow-top-navigation-by-user-activation',
             'allow-scripts',
          ],
          additionalAllowOptions: const [
            'accelerometer',
            'clipboard-write',
            'encrypted-media',
            'gyroscope',
            'picture-in-picture',
          ],
        ),
        navigationDelegate: (req) {
          print(req.content.toString());
          return NavigationDecision.navigate;
        },
        onPageStarted: (src) {
          print(src);
        },
        onWebResourceError: (err) {
          print(err.description);
        },
      ),
//      Column(
//        children: <Widget>[
//          Expanded(
//            flex: 3,
//            child: Container(),
//          ),
//          Expanded(
//              flex: 1,
//              child: Container(
//                width: 500,
//                child: EasyWebView(
//                  src: src3,
//                  onLoaded: (_) {
//                    print('$key3: Loaded: $src3');
//                  },
//                  isMarkdown: _isMarkdown,
//                  convertToWidgets: _useWidgets,
//                  key: key3,
//                ),
//              )),
//        ],
//      )
    ]);
  }
}

// -----------------------------------------------------------------------------
