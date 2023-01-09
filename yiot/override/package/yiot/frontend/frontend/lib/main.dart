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

import 'package:flutter/material.dart';

import 'routes/routes.dart';

import 'pages/container/container-page.dart';
import 'pages/presentation-page.dart';
import 'pages/landing-page.dart';

// -----------------------------------------------------------------------------
void main() {
  runApp(YIoTLanding());
}

// -----------------------------------------------------------------------------
class YIoTLanding extends StatefulWidget {
  @override
  _YIoTLandingState createState() => _YIoTLandingState();
}

// -----------------------------------------------------------------------------
class _YIoTLandingState extends State<YIoTLanding> {
  var _routes = new YIoTRoutes();

  @override
  void initState() {
    super.initState();

    // Default page is landing
    _routes.registerDefault(ContainerPage(
      routeData: "/",
      body: YIoTLandingPage(),
    ));

    // Presentation page
    _routes.register(ContainerPage(
      routeData: "/presentation",
      body: YIoTPresentationPage(),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateTitle: (BuildContext context) => 'Your IoT',
        debugShowCheckedModeBanner: false,

        // --- Routes ---
        onGenerateRoute: _routes.generator,
    );
  }
}

// -----------------------------------------------------------------------------
