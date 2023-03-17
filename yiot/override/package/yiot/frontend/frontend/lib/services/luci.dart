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
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yiot_portal/services/helpers.dart';

// ---------------------------------------------------------------------------
//
//  Luci RPC commands
//
enum LuciCommand {
  login("login");

  final String val;
  const LuciCommand(this.val);
}

// ---------------------------------------------------------------------------
//
//  Luci Service response
//
class LuciResponse {
  late String data;
  late String error;
  LuciResponse({required this.data, required this.error});
}

// ---------------------------------------------------------------------------
//
//  Luci Service class
//
class LuciService {
  static const _ENDPOINT_AUTH =
      "/cgi-bin/luci/rpc/auth";

  // ---------------------------------------------------------------------------
  //
  //  General RPC Luci call
  //
  static Future<LuciResponse> _rpcRequest(String endpoint, int id, LuciCommand command, List<String> params) async {
    // Prepare URL
    Uri url = Uri.parse(YIoTServiceHelpers.baseURL() + endpoint);

    // Prepare Body
    var body = json.encode({'id': id, 'method': command.val, 'params': params});

    // RPC processing
    final response = await http.post(url, body: body);

    // Check response
    if (response.statusCode != 200) {
      return LuciResponse(
        data: "",
        error: "Cannot process Luci RPC ${endpoint}, command: ${command}",
      );
    }

    // Parse JSON response
    final responseJson = json.decode(response.body);
    String data = "";
    String error;

    if (responseJson['result'] != null) {
      data = responseJson['result'];
    }

    if (responseJson['error'] == null) {
      error = "";
    } else {
      error = responseJson['error'];
    }

    if (data != "" && error == "") {
      document.cookie = "sysauth_http=${data}";
    }

    return LuciResponse(
      data: data,
      error: error,
    );
  }

  // ---------------------------------------------------------------------------
  //
  //  Luci login
  //
  static Future<LuciResponse> login(String user, String password) async {
    return _rpcRequest(_ENDPOINT_AUTH, 1, LuciCommand.login, [user, password]);
  }
}
// -----------------------------------------------------------------------------