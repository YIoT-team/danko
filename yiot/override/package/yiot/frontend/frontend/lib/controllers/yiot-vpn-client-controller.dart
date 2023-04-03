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

import 'package:yiot_portal/model/yiot-vpn-client-model.dart';

import 'package:yiot_portal/services/luci.dart';
import 'package:yiot_portal/session/yiot-session.dart';


// ---------------------------------------------------------------------------
//
//  YIoT VPN Client Controller
//
class YIoTVpnClientController {

  // ---------------------------------------------------------------------------
  //
  //  Get token
  //
  static Future<String> _token() async {
    return await YIoTSession().session();
  }

  // ---------------------------------------------------------------------------
  //
  //  Apply VPN Client configuration
  //
  static Future<bool> apply(String name, List<int> data) async {

    // Prepare configuration string
    final config = utf8.decode(data);

    // Parse VPN configuration data
    final vpn = YIoTVpnClientModel.fromConf(name, config);
    vpn.show();

    // Check if valid
    if (!vpn.valid) {
      return false;
    }

    // Get token
    final token = await _token();

    // Apply configuration via LUCI RPC API

    // uci set network.wg_yiot=interface
    // uci set network.wg_yiot.proto='wireguard'
    // uci add network wireguard_wg_yiot # =cfg0a5bf0
    // uci set network.@wireguard_wg_yiot[-1].description='cv2se.conf'
    // uci set network.@wireguard_wg_yiot[-1].public_key='U6v6FJX612zQloyjG33zRCka2WxSXV8jowOlAHkvt0E='
    // uci set network.@wireguard_wg_yiot[-1].preshared_key='A6BfYNOt7PGagnNn3F5P7IdwC9nMDBhvbij7s5+cksE='
    // uci add_list network.@wireguard_wg_yiot[-1].allowed_ips='10.221.17.0/24'
    // uci set network.@wireguard_wg_yiot[-1].route_allowed_ips='1'
    // uci set network.@wireguard_wg_yiot[-1].persistent_keepalive='15'
    // uci set network.@wireguard_wg_yiot[-1].endpoint_host='104.248.103.171'
    // uci set network.@wireguard_wg_yiot[-1].endpoint_port='30004'
    // uci set network.wg_yiot.private_key='4ISDdAoJpDjvY+FvQXvtetDZecO7phF4jB9dVqjsnEY='
    // uci add_list network.wg_yiot.addresses='10.221.17.4/32'


    LuciResponse res;

    // Encode to base 64 and save flow file
    res = await LuciService.uciSet(token, 'network.${vpn.interfaceName}', 'interface');
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.${vpn.interfaceName}.proto', vpn.protocol);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciAdd(token, 'network', vpn.networkName);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].description', vpn.description);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].public_key', vpn.publicKey);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].preshared_key', vpn.presharedKey);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].allowed_ips', vpn.allowedIPs);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].route_allowed_ips', '1');
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].persistent_keepalive', vpn.keepAliveInterval);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].endpoint_host', vpn.endpointHost);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.@${vpn.networkName}[-1].endpoint_port', vpn.endpointPort);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    res = await LuciService.uciSet(token, 'network.${vpn.interfaceName}.private_key', vpn.privateKey);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    // uci add_list network.wg_yiot.addresses='10.221.17.4/32'
    res = await LuciService.uciSet(token, 'network.${vpn.interfaceName}.addresses', vpn.addresses);
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    //
    //  Commit changes
    //
    res = await LuciService.uciCommit(token, 'network');
    if (!res.error.isEmpty) {
      YIoTVpnClientController._dropChanges();
      return false;
    }

    return true;
  }

  //
  //  Drop UCI changes
  //
  static void _dropChanges() {

  }

}
// -----------------------------------------------------------------------------
