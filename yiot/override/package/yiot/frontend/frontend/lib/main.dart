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
import 'package:yiot_portal/pages/container/container-page.dart';

//
//  Pages
//
import 'package:yiot_portal/pages/home-page.dart';

import 'package:yiot_portal/pages/data/flow-page.dart';

import 'package:yiot_portal/pages/vpn/vpn-server-page.dart';
import 'package:yiot_portal/pages/vpn/vpn-client-page.dart';

import 'package:yiot_portal/pages/hardware/wifi-page.dart';
import 'package:yiot_portal/pages/hardware/ethernet-page.dart';
import 'package:yiot_portal/pages/hardware/serial-page.dart';

import 'package:yiot_portal/pages/system/reboot-page.dart';
import 'package:yiot_portal/pages/system/logs-page.dart';

//
//  Bloc's
//
import 'package:yiot_portal/bloc/yiot_provision_bloc.dart';

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

    // Data
    _routes.registerDefault(ContainerPage(
      routeData: "/data/flow",
      body: DataFlowPage(),
    ));

    //
    //  VPN
    //

    // Server
    _routes.registerDefault(ContainerPage(
      routeData: "/vpn/server",
      body: VpnServerPage(),
    ));

    // Client
    _routes.registerDefault(ContainerPage(
      routeData: "/vpn/client",
      body: VpnClientPage(),
    ));


    //
    // Hardware
    //

    // WiFi
    _routes.registerDefault(ContainerPage(
      routeData: "/hardware/wifi",
      body: WiFiPage(),
    ));

    // Ethernet
    _routes.registerDefault(ContainerPage(
      routeData: "/hardware/ethernet",
      body: EthernetPage(),
    ));

    // Serial
    _routes.registerDefault(ContainerPage(
      routeData: "/hardware/serial",
      body: SerialPage(),
    ));

    //
    //  System
    //

    // Logs page
    _routes.registerDefault(ContainerPage(
      routeData: "/system/logs",
      body: LogsPage(),
    ));

    // Reboot page
    _routes.registerDefault(ContainerPage(
      routeData: "/system/reboot",
      body: RebootPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // --- Providers ---
      providers: [
        Provider(
          create: (context) {
            return YiotProvisionBloc();
          },
        ),
      ],
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) => "YIoT CV-2SE",
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
