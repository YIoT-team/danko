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
import 'package:yiot_portal/services/luci.dart';
import 'package:yiot_portal/session/yiot-session.dart';

// ---------------------------------------------------------------------------
//
//  YIoT Flow Controller
//
class YIoTFlowController {
  static const _FLOW_FILE =
      "/etc/yiot-flow.json";

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
  static Future<bool> save(String data) async {
    // Get token
    final token = await _token();

    // base64 codec
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Encode to base 64 and save file
    final res = await LuciService.fsSave(token, _FLOW_FILE, stringToBase64.encode(data));

    return res.error.isEmpty;
  }

  // ---------------------------------------------------------------------------
  //
  //  Load YIoT Flow
  //
  static Future<String> load() async {

    // Get token
    final token = await _token();

    // Load file data
    final res = await LuciService.fsLoad(token, _FLOW_FILE);

    // Check for an error
    if (res.data.isEmpty) {
      return "";
    }

    // base64 codec
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Decode base64 and return
    return stringToBase64.decode(res.data);
  }
}
// -----------------------------------------------------------------------------