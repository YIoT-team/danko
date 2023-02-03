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

class YIoTNamedParam extends StatefulWidget {
  final String name;
  final Widget body;

  YIoTNamedParam(
      {required this.name,
      required this.body,
      Key? key});

  @override
  State<YIoTNamedParam> createState() => _YIoTNamedParamState(
        name: name,
        body: body,
      );
}

class _YIoTNamedParamState extends State<YIoTNamedParam> {
  final String name;
  final Widget body;

  _YIoTNamedParamState(
      {required this.name,
      required this.body});

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
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
