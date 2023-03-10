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

import 'package:yiot_portal/services/helpers.dart';

import 'package:webviewx/webviewx.dart';

// -----------------------------------------------------------------------------
class LuciPartPage extends StatefulWidget {
  late final String url;
  late final String title;
  LuciPartPage({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  _LuciPartPageState createState() =>
      _LuciPartPageState(title: title, url: url);
}

// -----------------------------------------------------------------------------
class _LuciPartPageState extends State<LuciPartPage> {
  late final String url;
  late final String title;
  _LuciPartPageState({required this.title, required this.url}) : super();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    var components = <Widget>[];

    // Add title and divider if not empty
    if (!title.isEmpty) {
      components.add(
        YIoTTitle(title: title),
      );
      components.add(
        Divider(color: Colors.black),
      );
    }

    // Add WebView component
    components.add(
      WebViewX(
        width: 1024,
        height: screenSize.height - 100,
        initialContent: url,
        initialSourceType: SourceType.url,
      ),
    );

    return Column(
        children: components,
    );
  }
}

// -----------------------------------------------------------------------------
