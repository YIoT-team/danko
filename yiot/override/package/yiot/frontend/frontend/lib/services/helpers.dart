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

import 'dart:html';
import 'package:flutter/foundation.dart';

class YIoTServiceHelpers {
  // ---------------------------------------------------------------------------
  //
  //  Returns base URL
  //
  static String baseURL() {
    if (!kReleaseMode) {
      return "http://192.168.0.249";
    }
    return window.location.origin;
  }

  // ---------------------------------------------------------------------------
  //
  //  WireGuard server UI helpers
  //
  static String wgServerURL() => baseURL() + "/wireguard";

  // ---------------------------------------------------------------------------
  //
  //  LUCI UI helpers
  //
  static String luciURL() => baseURL() + "/cgi-bin/luci";
  static String ttyURL() => luciURL() + "/admin/services/ttyd";
  static String rebootURL() => luciURL() + "/admin/system/reboot";
  static String logsURL() => luciURL() + "/admin/status/logs";
  static String serialURL() => luciURL() + "/admin/services/ser2net";
  static String wgClientsURL() => luciURL() + "/admin/status/wireguard";

  // ---------------------------------------------------------------------------
  //
  //  CV-2SE documentation
  //
  static String wgAddHelpURL() => "https://docs.yiot.dev/docs/cv2se-faq#add-wireguard-connection";
}

// -----------------------------------------------------------------------------