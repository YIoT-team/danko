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

import 'package:yiot_portal/model/flow/helpers/yiot-model-base.dart';
import 'package:yiot_portal/controllers/yiot-flow-controller.dart';

import 'package:yiot_portal/components/ui/yiot-title.dart';

import 'package:flutter_flow_chart/flutter_flow_chart.dart';

// -----------------------------------------------------------------------------

class YIoTConnectionEditor extends StatelessWidget {
  late final YIoTFlowController controller;
  late final Handler handler;
  late final FlowElement element;

  YIoTConnectionEditor({
    super.key,
    required this.controller,
    required this.handler,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      YIoTTitle(title: "Connection"),
      Divider(
        color: Colors.black,
      ),
      Row(
        children: [
          FloatingActionButton(
            child: const Icon(Icons.delete),
            mini: true,
            backgroundColor: Colors.redAccent,
            onPressed: () {
              controller.dashboard.removeElementConnection(element, handler);
            },
          ),
        ],
      ),
    ]);
  }
}

// -----------------------------------------------------------------------------
