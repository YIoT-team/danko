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

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:yiot_portal/components/ui/yiot-icons.dart';

class MainMenu {
  static const List<AdminMenuItem> items = const [

    //
    //  Home page
    //
    AdminMenuItem(
      title: 'Home',
      icon: Icons.home,
      route: '/',
    ),

    //
    //  Data
    //
    AdminMenuItem(
      title: 'Data Flow',
      icon: Icons.account_tree_outlined,
      route: '/data/flow',
    ),

    //
    //  VPN
    //
    AdminMenuItem(
      title: 'VPN',
      icon: YIoTIcons.vpn_lock,
      children: [
        AdminMenuItem(
          title: 'Server',
          icon: YIoTIcons.server,
          route: '/vpn/server',
        ),
        AdminMenuItem(
          title: 'Client',
          icon: Icons.private_connectivity,
          route: '/vpn/client',
        ),
      ],
    ),

    //
    //  Hardware
    //
    AdminMenuItem(
      title: 'Hardware',
      icon: YIoTIcons.microchip,
      children: [
        AdminMenuItem(
          title: 'Ethernet',
          icon: YIoTIcons.ethernet,
          route: '/hardware/ethernet',
        ),
        AdminMenuItem(
          title: 'WiFi',
          icon: Icons.wifi,
          route: '/hardware/wifi',
        ),
        AdminMenuItem(
          title: 'Serial',
          icon: Icons.settings_ethernet,
          route: '/hardware/serial',
        ),
      ],
    ),

    //
    //  System
    //
    AdminMenuItem(
      title: 'System',
      icon: Icons.settings,
      children: [
        AdminMenuItem(
          title: 'Logs',
          icon: Icons.text_snippet_outlined,
          route: '/system/logs',
        ),
        AdminMenuItem(
          title: 'Reboot',
          icon: Icons.restart_alt,
          route: '/system/reboot',
        ),
      ],
    ),
  ];
}

// -----------------------------------------------------------------------------