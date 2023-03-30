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


  // ---------------------------------------------------------------------------
  //
  //  Apply VPN Client configuration
  //
  static Future<bool> apply(String name, List<int> data) async {
    final config = utf8.decode(data);
    final vpnModel = YIoTVpnClientModel.fromConf(name, config);

    vpnModel.show();

    return false;
  }

}
// -----------------------------------------------------------------------------
