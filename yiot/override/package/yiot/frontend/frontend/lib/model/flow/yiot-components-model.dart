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

import 'dart:convert';
import 'package:yiot_portal/model/flow/helpers/yiot-model-base.dart';
import 'package:yiot_portal/model/flow/helpers/yiot-model-factory.dart';

class YIoTComponentsModel {
  var _components = Map<String, YIoTFlowComponentBase>();

  bool add(YIoTFlowComponentBase component) {
    _components[component.id] = component;
    return true;
  }

  bool remove(YIoTFlowComponentBase component) {
    return null != _components.remove(component.id);
  }

  YIoTFlowComponentBase? get(String id) {
    if (_components.containsKey(id)) {
      return _components[id];
    }
    return null;
  }

  bool update(YIoTFlowComponentBase component) {
    _components[component.id] = component;
    return true;
  }

  String toJson() {
    var map = <String, dynamic>{};
    _components.forEach((key, value) {
      map[key] = value.toMap();
    });

    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(map);
  }

  bool fromJson(Map<String, dynamic> json) {
    var newComponents = Map<String, YIoTFlowComponentBase>();

    json.forEach((key, value) {
      final element = YIoTFlowComponentFactory.fromJson(value);
      if (element != null) {
        newComponents[key] = element;
      }
    });

    _components = newComponents;

    return true;
  }
}

// -----------------------------------------------------------------------------
