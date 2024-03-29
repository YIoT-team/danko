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
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:yiot_portal/model/flow/helpers/yiot-model-base.dart';
import 'package:yiot_portal/model/flow/yiot-ip-model.dart';
import 'package:yiot_portal/model/flow/yiot-serial-model.dart';
import 'package:yiot_portal/model/flow/yiot-nat-model.dart';
import 'package:yiot_portal/model/flow/yiot-components-model.dart';

import 'package:yiot_portal/services/luci.dart';
import 'package:yiot_portal/session/yiot-session.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';

// ---------------------------------------------------------------------------
//
//  YIoT Flow Actions
//
enum YIoTFlowAction {
  // Inputs
  addInputIpPort,
  addInputSerial,

  // Outputs
  addOutputIpPort,
  addOutputSerial,

  // Processing
  addProcessingForwarding,

  // Operation
  operationSave,
  operationDownload,
  operationUpload,
}

// ---------------------------------------------------------------------------
//
//  YIoT Flow Controller
//
class YIoTFlowController {
  late Dashboard dashboard;
  final _model = YIoTComponentsModel();

  static const _FLOW_FILE = "/etc/yiot-flow.json";
  static const _FLOW_PARAMS_FILE = "/etc/yiot-flow-params.json";
  static const _ELEMENT_BASE_SIZE = Size(200, 70);
  static const _ELEMENT_INPUT_COLOR = Colors.green;
  static const _ELEMENT_OUTPUT_COLOR = Colors.redAccent;
  static const _ELEMENT_PROCESSING_COLOR = Colors.blueAccent;

  // ---------------------------------------------------------------------------
  //
  //  Constructor
  //
  YIoTFlowController({required this.dashboard});

  // ---------------------------------------------------------------------------
  //
  //  Get token
  //
  static Future<String> _token() async {
    return await YIoTSession().session();
  }

  // ---------------------------------------------------------------------------
  //
  //  Save YIoT Flow
  //
  Future<bool> save() async {

    // TODO: USE SINGLE DATA FILE

    // Get token
    final token = await _token();

    // Prepare params
    final flow = dashboard.prettyJson();
    final params = _model.toJson();

    // base64 codec
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Encode to base 64 and save flow file
    final resFlow = await LuciService.fsSave(
        token, _FLOW_FILE, stringToBase64.encode(flow));

    // Encode to base 64 and save params file
    final resParams = await LuciService.fsSave(
        token, _FLOW_PARAMS_FILE, stringToBase64.encode(params));

    return resFlow.error.isEmpty && resParams.error.isEmpty;
  }

  // ---------------------------------------------------------------------------
  //
  //  Apply YIoT Flow from JSON
  //
  bool _apply(String jsonString) {
    // Check for an error
    if (jsonString.isEmpty) {
      return false;
    }

    // Apply data if present
    dashboard.elements.clear();
    List<FlowElement> all = List<FlowElement>.from(
      ((json.decode(jsonString))['elements'] as List<dynamic>).map<FlowElement>(
        (x) => FlowElement.fromMap(x as Map<String, dynamic>),
      ),
    );
    for (int i = 0; i < all.length; i++) {
      dashboard.addElement(all.elementAt(i));
    }
    dashboard.notifyListeners();

    return true;
  }

  // ---------------------------------------------------------------------------
  //
  //  Load YIoT Flow
  //
  Future<bool> load() async {

    // TODO: USE SINGLE DATA FILE

    // Get token
    final token = await _token();

    // base64 codec
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Load params
    final resParams = await LuciService.fsLoad(token, _FLOW_PARAMS_FILE);

    // Check for an error
    if (resParams.data.isEmpty) {
      return false;
    }

    // Decode base64 and return
    final jsonParamsString = stringToBase64.decode(resParams.data);

    // Apply model params
    _model.fromJson(json.decode(jsonParamsString));

    // ---------------

    // Load float data
    final res = await LuciService.fsLoad(token, _FLOW_FILE);

    // Check for an error
    if (res.data.isEmpty) {
      return false;
    }

    // Decode base64
    final jsonString = stringToBase64.decode(res.data);

    // Apply
    return _apply(jsonString);
  }

  // ---------------------------------------------------------------------------
  //
  //  Add component
  //
  Future<bool> _add(YIoTFlowComponentBase model) async {
    // Prepare component parameters
    late final Color color;
    var connectors = <Handler>[];
    if (model.direction == YIoTFlowDirection.kInput) {
      color = _ELEMENT_INPUT_COLOR;
      connectors.add(Handler.rightCenter);
    } else if (model.direction == YIoTFlowDirection.kOutput) {
      color = _ELEMENT_OUTPUT_COLOR;
      connectors.add(Handler.leftCenter);
    } else {
      color = YIoTFlowController._ELEMENT_PROCESSING_COLOR;
      connectors.add(Handler.rightCenter);
      connectors.add(Handler.leftCenter);
    }

    // Create element
    final el = FlowElement(
      size: _ELEMENT_BASE_SIZE,
      text: model.name(),
      borderColor: color,
      kind: ElementKind.rectangle,
      handlers: connectors,
    );

    // Set ID
    el.id = model.id;

    // Add Element to dashboard
    dashboard.addElement(el);

    return true;
  }

  // ---------------------------------------------------------------------------
  //
  //  Delete component
  //
  Future<bool> delete(FlowElement element) async {
    // Delete Element from dashboard
    dashboard.removeElement(element);
    return true;
  }

  // ---------------------------------------------------------------------------
  //
  //  Get model
  //
  YIoTFlowComponentBase? getModel(String id) => _model.get(id);

  // ---------------------------------------------------------------------------
  //
  //  Update element
  //
  bool update(YIoTFlowComponentBase model) {
    _model.update(model);
    dashboard.elements.forEach((element) {
      if (element.id == model.id) {
        element.setText(model.name());
      }
    });
    return true;
  }

  // ---------------------------------------------------------------------------
  //
  //  Process command
  //
  Future<bool> processCommand(YIoTFlowAction action, dynamic data) async {
    // Prepare ID
    final id = const Uuid().v4();
    ;

    // Save command
    if (action == YIoTFlowAction.operationSave) {
      return this.save();
    }

    // Import command
    if (action == YIoTFlowAction.operationUpload) {
      if (!(data is List<int>?) || data == null) {
        return false;
      }
      return _apply(utf8.decode(data));
    }

    // Export command
    if (action == YIoTFlowAction.operationUpload) {
      return false;
    }

    // Add IP : Port input
    if (action == YIoTFlowAction.addInputIpPort) {
      final data = YIoTIpModel(id: id, direction: YIoTFlowDirection.kInput);
      if (_model.add(data)) {
        return _add(data);
      }
      return true;
    }

    // Add Serial input
    if (action == YIoTFlowAction.addInputSerial) {
      final data = YIoTSerialModel(id: id, direction: YIoTFlowDirection.kInput);
      if (_model.add(data)) {
        return _add(data);
      }
      return true;
    }

    // Add IP : Port output
    if (action == YIoTFlowAction.addOutputIpPort) {
      final data = YIoTIpModel(id: id, direction: YIoTFlowDirection.kOutput);
      if (_model.add(data)) {
        return _add(data);
      }
      return true;
    }

    // Add Serial input
    if (action == YIoTFlowAction.addOutputSerial) {
      final data = YIoTSerialModel(id: id, direction: YIoTFlowDirection.kOutput);
      if (_model.add(data)) {
        return _add(data);
      }
    }

    // Add Forwarding
    if (action == YIoTFlowAction.addProcessingForwarding) {
      final data = YIoTNatModel(id: id);
      if (_model.add(data)) {
        return _add(data);
      }
    }

    return false;
  }
}
// -----------------------------------------------------------------------------
