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

import 'package:yiot_portal/model/flow/helpers/yiot-model-base.dart';
import 'package:yiot_portal/model/flow/yiot-ip-model.dart';
import 'package:yiot_portal/model/flow/yiot-nat-model.dart';

// ---------------------------------------------------------------------------
//
//  YIoT Flow component factory
//
abstract class YIoTFlowComponentFactory {
  static YIoTFlowComponentBase? fromJson(Map<String, dynamic> json) {
    try {
      // Get component ID
      final id = json[YIoTFlowComponentBase.YIOT_COMPONENT_ID_FIELD];

      // Get component direction
      late final direction;
      final directionStr =
          json[YIoTFlowComponentBase.YIOT_COMPONENT_DIRECTION_FIELD];
      if (directionStr == YIoTFlowDirection.kInput) {
        direction = YIoTFlowDirection.kInput;
      } else if (directionStr == YIoTFlowDirection.kOutput) {
        direction = YIoTFlowDirection.kOutput;
      } else if (directionStr == YIoTFlowDirection.kMiddle) {
        direction = YIoTFlowDirection.kMiddle;
      } else {
        print("Cannot load a component, due to unknown direction");
        return null;
      }

      // Get component type
      final type = json[YIoTFlowComponentBase.YIOT_COMPONENT_TYPE_FIELD];

      // Input/Output - IP:Port
      if (type == YIoTFlowComponent.kFlowComponentIP.toString()) {
        var res = YIoTIpModel(
          id: id,
          direction: direction,
        );
        if (res.fromJson(json)) {
          return res;
        }
      }

      // Processing - NAT
      if (type == YIoTFlowComponent.kFlowComponentNAT.toString()) {
        var res = YIoTNatModel(
          id: id,
        );
        if (res.fromJson(json)) {
          return res;
        }
      }

    } catch (_) {}

    return null;
  }
}

// -----------------------------------------------------------------------------
