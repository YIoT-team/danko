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
import 'package:http/http.dart' as http;

class LuciService {
  static const _ENDPOINT_LOGIN =
      "/cgi-bin/luci/rpc/auth";

  // ---------------------------------------------------------------------------
  //
  //  Luci login
  //
  static Future<String> login(String user, String password) async {
//    Uri url = Uri.parse(
////        YIoTBackendParams.backendBase() + _ENDPOINT_JENKINS_START);
////
////    // Prepare WireGuard configuration
////    var config = "";
////    if (wgConfig != "") {
////      // Wrap config to base64
////      Codec<String, String> stringToBase64 = utf8.fuse(base64);
////      config = stringToBase64.encode(wgConfig);
////    }
////
////    var body = json.encode({'user': user, 'password': password, "subnet": "10.221.17.0/24", "config": config});
////
////    var headers = YIoTRestHelpers.headers(token, owner);
////    final response = await http.post(url, body: body, headers: headers);
////
////    if (response.statusCode != 200) {
////      return Future.error("Cannot Start MQTT Service");
////    }
////
////    final responseJson = json.decode(response.body);
////    final responseInfo = YIoTMqttInfoModel(responseJson);
////    if (responseInfo.isValid) {
////      var healthUrl = responseInfo.url + responseInfo.healthUrl;
////      await YIoTRestHelpers.waitActive(healthUrl, token, owner, 5, 15);
////      return responseInfo;
////    }
////
////    YIoTServiceHelpers.processError(url, response);
////    return Future.error("Cannot decode Owner's info");
    return "test";
  }
}
// -----------------------------------------------------------------------------