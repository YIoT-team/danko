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

// -----------------------------------------------------------------------------

class YIoTParamEditor extends StatelessWidget {
  late final YIoTFlowController controller;
  late final YIoTFlowComponentBase model;
  late final Widget body;

  YIoTParamEditor({
    super.key,
    required this.controller,
    required this.model,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare Title
    var title = model.baseName;
    if (model.direction == YIoTFlowDirection.kInput) {
      title += " Input";
    } else if (model.direction == YIoTFlowDirection.kOutput) {
      title += " Output";
    } else if (model.direction == YIoTFlowDirection.kMiddle) {
      title += " Processing";
    }

    return Column(children: [
      YIoTTitle(title: title),
      Divider(
        color: Colors.black,
      ),
      Row(
        children: [
          FloatingActionButton(
              child: const Icon(Icons.aspect_ratio_rounded),
              mini: true,
              onPressed: () {
                controller.dashboard.elements.forEach((element) {
                  if (element.id == model.id) {
                    controller.dashboard.setElementResizable(element, true);
                    return;
                  }
                });
              }),
          SizedBox(width: 20),
          FloatingActionButton(
              child: const Icon(Icons.delete),
              mini: true,
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                controller.dashboard.elements.forEach((element) {
                  if (element.id == model.id) {
                    controller.delete(element);
                    return;
                  }
                });
              }),
        ],
      ),
      Divider(
        color: Colors.black,
      ),
      body,
    ]);
  }
}

// -----------------------------------------------------------------------------
