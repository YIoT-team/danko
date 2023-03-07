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

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiot_portal/services/luci.dart';

class YIoTSession {
  static const _COOKIE_SESSION =
      "_luci_session_";
  static const _COOKIE_SESSION_TIME =
      "_luci_session_time_";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> isActive() async {
    final SharedPreferences prefs = await _prefs;

    // TODO: Check session timeout

    return prefs.getString(_COOKIE_SESSION) != null;
  }

  Future<bool> login(String user, String password) async {
      final SharedPreferences prefs = await _prefs;

      // Luci login
      final res = await LuciService.login(user, password);
      final session = res.data;

      // Return False if not successful
      if (session == "") {
        return false;
      }

      // Save session
      await prefs.setString(_COOKIE_SESSION, session);
      await prefs.setInt(_COOKIE_SESSION_TIME, DateTime.now().millisecondsSinceEpoch);

      return true;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(_COOKIE_SESSION);
    await prefs.remove(_COOKIE_SESSION_TIME);
  }

  Future<String> session() async {
    if (!await isActive()) {
      return "";
    }

    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_COOKIE_SESSION) ?? "";
  }
}