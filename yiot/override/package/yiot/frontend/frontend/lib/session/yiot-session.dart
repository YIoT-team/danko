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

  static const _COOKIE_LIVE_TIME_MS =
      5 * 60 * 1000;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> isActive() async {
    final SharedPreferences prefs = await _prefs;

    // Check if cookie is present
    if (prefs.getString(_COOKIE_SESSION) == null) {
      return false;
    }

    // Get timestamp
    final timestamp = prefs.getInt(_COOKIE_SESSION_TIME);
    if (timestamp == null) {
      return false;
    }

    // Check if timestamp is outdated
    final dt = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (dt > _COOKIE_LIVE_TIME_MS) {
      return false;
    }

    return true;
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