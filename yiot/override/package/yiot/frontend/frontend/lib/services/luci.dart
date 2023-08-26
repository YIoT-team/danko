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
  // Auth
  login("login"),

  // UCI
  uciCommit("commit"),
  uciSet("set"),
  uciDel("delete"),
  uciDelAll("delete_all"),
  uciGet("get"),
  uciGetAll("get_all"),
  uciAdd("add"),
  uciAddList("add_list"),

  // File System
  fsLoad("readfile"),
  fsSave("writefile"),

  // Status
  statusCall("call");

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

  static const _ENDPOINT_UCI =
      "/cgi-bin/luci/rpc/uci";

  static const _ENDPOINT_FS =
      "/cgi-bin/luci/rpc/fs";

  // ---------------------------------------------------------------------------
  //
  //  General RPC Luci call
  //
  static Future<LuciResponse> _rpcRequest(String endpoint, LuciCommand command, List<String> params) async {
    final id = 1;

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
      data = responseJson['result'].toString();
    }

    if (responseJson['error'] == null) {
      error = "";
    } else {
      error = responseJson['error'].toString();
    }

    return LuciResponse(
      data: data,
      error: error,
    );
  }

  // ---------------------------------------------------------------------------
  //
  //  General RPC Luci call v2
  //
  static Future<LuciResponse> _ubusRequest(String token, String endpoint, LuciCommand command, List<dynamic> params) async {
    final id = 1;

    // Prepare URL
    Uri url = Uri.parse(YIoTServiceHelpers.baseURL() + endpoint);

    // Prepare Body
    var fullParams = <dynamic>[token];
    fullParams.addAll(params);
    var body = json.encode([{"jsonrpc":"2.0", 'id': id, 'method': command.val, 'params': fullParams}]);

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
    final responseJson = json.decode(response.body)[0];
    String data = "";
    String error;

    if (responseJson ['result'] != null) {
      data = json.encode(responseJson['result']);
    }

    if (responseJson['error'] == null) {
      error = "";
    } else {
      error = responseJson['error'].toString();
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
    // Login request
    final res = await _rpcRequest(_ENDPOINT_AUTH, LuciCommand.login, [user, password]);

    // Save token cookie
    if (res.data != "" && res.error == "") {
      document.cookie = "sysauth_http=${res.data}";
    }

    // Return result
    return res;
  }

  // ---------------------------------------------------------------------------
  //
  //  URL with token
  //
  static String urlWithToken(String url, String token) {
    return url + "?auth=" + token;
  }

  // ---------------------------------------------------------------------------
  //
  //  UBUS URL
  //
  static String urlUbus() {
    return "/ubus/?" + DateTime.now().millisecondsSinceEpoch.toString();
  }

  // ---------------------------------------------------------------------------
  //
  //  Param parser
  //
  static List<String> _parse(String param, int min, int max) {
    final components = param.split('.');
    var params = <String>[];

    // Get minimum number of parts
    for (var i = 0; i < min; i++) {
      var val = "";
      if (components.length > i) {
        val = components.elementAt(i);
      }
      params.add(val);
    }

    // Check if more parts available
    for (var i = min; i < max; i++) {
      if (components.length <= i) {
        break;
      }
      params.add(components.elementAt(i));
    }

    return params;
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI set
  //
  static Future<LuciResponse> uciSet(String token, String param, String value) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 2, 3);
    params.add(value);

    return _rpcRequest(url, LuciCommand.uciSet, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI add
  //
  static Future<LuciResponse> uciAdd(String token, String param, String value) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 1, 1);
    params.add(value);

    return _rpcRequest(url, LuciCommand.uciAdd, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI add list
  //
  static Future<LuciResponse> uciAddList(String token, String param, String value) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 2, 3);
    params.add(value);

    return _rpcRequest(url, LuciCommand.uciAddList, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI get
  //
  static Future<LuciResponse> uciGet(String token, String param) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 2, 3);

    return _rpcRequest(url, LuciCommand.uciGet, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI delete
  //
  static Future<LuciResponse> uciDel(String token, String param) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 2, 3);

    return _rpcRequest(url, LuciCommand.uciDel, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI delete all
  //
  static Future<LuciResponse> uciDelAll(String token, String param) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 1, 2);

    return _rpcRequest(url, LuciCommand.uciDelAll, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI get all
  //
  static Future<LuciResponse> uciGetAll(String token, String param) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 1, 2);

    return _rpcRequest(url, LuciCommand.uciGetAll, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  UCI commit
  //
  static Future<LuciResponse> uciCommit(String token, String param) async {
    final url = urlWithToken(_ENDPOINT_UCI, token);

    // Prepare params
    var params = _parse(param, 1, 1);

    return _rpcRequest(url, LuciCommand.uciCommit, params);
  }

  // ---------------------------------------------------------------------------
  //
  //  File load
  //
  static Future<LuciResponse> fsLoad(String token, String file) async {
    final url = urlWithToken(_ENDPOINT_FS, token);
    return _rpcRequest(url, LuciCommand.fsLoad, [file]);
  }

  // ---------------------------------------------------------------------------
  //
  //  File save
  //
  static Future<LuciResponse> fsSave(String token, String file, String value) async {
    final url = urlWithToken(_ENDPOINT_FS, token);
    return _rpcRequest(url, LuciCommand.fsSave, [file, value]);
  }

  // ---------------------------------------------------------------------------
  //
  //  Request WireGuard status
  //
  static Future<LuciResponse> getWireguard(String token) async {
    final url = urlUbus();
    return _ubusRequest(token, url, LuciCommand.statusCall, ["luci.wireguard", "getWgInstances", {}]);
  }
}
// -----------------------------------------------------------------------------