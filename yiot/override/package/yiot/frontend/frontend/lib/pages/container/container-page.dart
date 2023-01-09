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
import '../../routes/routed-widget.dart';
import '../../widgets/navbar.dart';
import '../../widgets/footer.dart';
import '../../utils/responsive-layout.dart';

class ContainerPage extends StatelessWidget implements RoutedWidgetInterface {
  ContainerPage({
    Key? key,
    required this.routeData,
    required this.body,
  }) : super(key: key);

  final Widget body;
  final String routeData;

  //
  //  RoutedWidgetInterface
  //
  String route() {
    return this.routeData;
  }

  String title() {
    return "";
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[
      SizedBox(
        height: 80.0,
        child: NavBar(),
      ),
      Divider(
        height: 1,
        color: Colors.white,
      ),
      this.body,
    ];

    if (ModalRoute.of(context)?.settings.name == '/') {
      content.add(
        SizedBox(
          height: ResponsiveLayout.fixGeometrySz(context, 50.0),
          child: YIoTFooter(),
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: content,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
