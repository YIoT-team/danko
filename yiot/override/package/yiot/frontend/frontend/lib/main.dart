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

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:yiot_portal/routes/routes.dart';
import 'package:yiot_portal/theme/theme.dart';
import 'package:yiot_portal/session/yiot-session.dart';
import 'package:yiot_portal/services/helpers.dart';

//
//  Pages
//
import 'package:yiot_portal/pages/container/container-page.dart';

import 'package:yiot_portal/pages/login-page.dart';
import 'package:yiot_portal/pages/home-page.dart';

import 'package:yiot_portal/pages/data/yiot-flow-page.dart';

import 'package:yiot_portal/pages/services/vpn/vpn-server-page.dart';
import 'package:yiot_portal/pages/services/vpn/vpn-client-page.dart';
import 'package:yiot_portal/pages/services/nodered/nodered-page.dart';
import 'package:yiot_portal/pages/services/mqtt/mqtt-page.dart';
import 'package:yiot_portal/pages/services/voice-control/voice-controll-page.dart';

import 'package:yiot_portal/pages/security/security-page.dart';
import 'package:yiot_portal/pages/devices/devices-page.dart';

import 'package:yiot_portal/pages/wifi/wifi-page.dart';
import 'package:yiot_portal/pages/hardware/ethernet-page.dart';
import 'package:yiot_portal/pages/hardware/serial-page.dart';

import 'package:yiot_portal/pages/luci-part-page.dart';
import 'package:yiot_portal/pages/system/logs-page.dart';

// -----------------------------------------------------------------------------
void main() {
  runApp(YIoTPortal());
}

// -----------------------------------------------------------------------------
class YIoTPortal extends StatefulWidget {
  @override
  _YIoTPortalState createState() => _YIoTPortalState();
}

// -----------------------------------------------------------------------------
class _YIoTPortalState extends State<YIoTPortal> {
  var _routes = new YIoTRoutes();

  @override
  void initState() {
    super.initState();

    // Default page (Home)
    _routes.registerDefault(ContainerPage(
      routeData: "/",
      body: HomePage(),
    ));

    // Login page
    _routes.register(LoginPage());

    // // Data
    // _routes.register(ContainerPage(
    //   routeData: "/data/flow",
    //   body: DataFlowPage(),
    // ));

    //
    //  VPN
    //

    // Server

    // Client
    _routes.register(ContainerPage(
      routeData: "/vpn/client",
      body: VpnClientPage(),
    ));

    //
    //  Security
    //
    _routes.register(ContainerPage(
      routeData: "/security",
      body: SecurityPage(),
    ));

    //
    //  Devices
    //
    _routes.register(ContainerPage(
      routeData: "/devices",
      body: DevicesPage(),
    ));

    //
    //  Services
    //
    _routes.register(ContainerPage(
      routeData: "/mqtt",
      body: MqttPage(),
    ));

    _routes.register(ContainerPage(
      routeData: "/nodered",
      body: NodeRedPage(),
    ));

    _routes.register(ContainerPage(
      routeData: "/voice",
      body: VoiceControlPage(),
    ));

    //
    // Hardware
    //

    // WiFi
    _routes.register(ContainerPage(
      routeData: "/hardware/wifi",
      body: WiFiPage(),
    ));

    // Ethernet
    _routes.register(ContainerPage(
      routeData: "/hardware/ethernet",
      body: EthernetPage(),
    ));

    // Serial
    _routes.register(ContainerPage(
      routeData: "/hardware/serial",
      body: LuciPartPage(title: "Serial", url: YIoTServiceHelpers.serialURL()),
    ));

    //
    //  System
    //

    // Terminal page
    _routes.register(ContainerPage(
      routeData: "/system/terminal",
      body: LuciPartPage(title: "Terminal", url: YIoTServiceHelpers.ttyURL()),
    ));

    // Logs page
    _routes.register(ContainerPage(
      routeData: "/system/logs",
      body: LuciPartPage(title: "", url: YIoTServiceHelpers.logsURL()),
    ));

    // Reboot page
    _routes.register(ContainerPage(
      routeData: "/system/reboot",
      body: LuciPartPage(title: "", url: YIoTServiceHelpers.rebootURL()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // --- Providers ---
      providers: [
        Provider(
          create: (context) {
            return YIoTSession();
          },
        ),
      ],
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) => "YIoT Danko",
        debugShowCheckedModeBanner: false,

        // --- Theme ---
        theme: YIoTTheme.current(),

        // --- Routes ---
        onGenerateRoute: _routes.generator,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
