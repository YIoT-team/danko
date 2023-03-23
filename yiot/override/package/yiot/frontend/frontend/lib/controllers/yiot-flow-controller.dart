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
import 'package:flutter/material.dart';
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

  static const _FLOW_FILE = "/etc/yiot-flow.json";
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
  Future<bool> _save(String data) async {
    // Get token
    final token = await _token();

    // base64 codec
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Encode to base 64 and save file
    final res = await LuciService.fsSave(
        token, _FLOW_FILE, stringToBase64.encode(data));

    return res.error.isEmpty;
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
  Future<bool> _load() async {
    // Get token
    final token = await _token();

    // Load file data
    final res = await LuciService.fsLoad(token, _FLOW_FILE);

    // Check for an error
    if (res.data.isEmpty) {
      return false;
    }

    // base64 codec
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Decode base64 and return
    final jsonString = stringToBase64.decode(res.data);

    return _apply(jsonString);
  }

  // ---------------------------------------------------------------------------
  //
  //  Add component
  //
  Future<bool> _add(String title, Color color, List<Handler> connectors) async {
    // Add Element to dashboard
    dashboard.addElement(FlowElement(
      size: _ELEMENT_BASE_SIZE,
      text: title,
      borderColor: color,
      kind: ElementKind.rectangle,
      handlers: connectors,
    ));

    return true;
  }

  // ---------------------------------------------------------------------------
  //
  //  Process command
  //
  Future<bool> processCommand(YIoTFlowAction action, dynamic data) async {
    // Save command
    if (action == YIoTFlowAction.operationSave) {
      return this._save(dashboard.prettyJson());
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
      return _add("[ip]", _ELEMENT_INPUT_COLOR, <Handler>[Handler.rightCenter]);
    }

    // Add Serial input
    if (action == YIoTFlowAction.addInputSerial) {
      return _add("[serial]", _ELEMENT_INPUT_COLOR, <Handler>[Handler.rightCenter]);
    }

    // Add IP : Port output
    if (action == YIoTFlowAction.addOutputIpPort) {
      return _add("[ip]", _ELEMENT_OUTPUT_COLOR, <Handler>[Handler.leftCenter]);
    }

    // Add Serial input
    if (action == YIoTFlowAction.addOutputSerial) {
      return _add("[serial]", _ELEMENT_OUTPUT_COLOR, <Handler>[Handler.leftCenter]);
    }

    // Add Forwarding
    if (action == YIoTFlowAction.addProcessingForwarding) {
      return _add("[forward]", _ELEMENT_PROCESSING_COLOR, <Handler>[Handler.leftCenter, Handler.rightCenter]);
    }

    return false;
  }
}
// -----------------------------------------------------------------------------
