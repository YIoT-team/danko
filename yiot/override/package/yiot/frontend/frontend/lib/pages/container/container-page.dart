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
import 'package:provider/provider.dart';
import 'package:yiot_portal/theme/theme.dart';

import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import 'package:yiot_portal/routes/routed-widget.dart';
import 'package:yiot_portal/pages/container/main-menu.dart';

import 'package:yiot_portal/components/ui/yiot-link-button.dart';

import 'package:yiot_portal/session/yiot-session.dart';

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

  IconData? icon() {
    return null;
  }

  String title() {
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<YIoTSession>(context).isActive(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final bool active = snapshot.data;
            if (!active) {
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.of(context).pushNamed('/login');
              });
              return Text("");
            } else {
              return AdminScaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text("YIoT CV-2SE"),
                  centerTitle: true,
                ),
                sideBar: SideBar(
                  backgroundColor: YIoTTheme.backgroundColor,
                  activeBackgroundColor: Colors.black26,
                  borderColor: YIoTTheme.borderColor,
                  iconColor: YIoTTheme.iconColor,
                  activeIconColor: YIoTTheme.activeIconColor,
                  textStyle: TextStyle(
                    color: YIoTTheme.menuFontColor,
                    fontSize: YIoTTheme.fontH3(context),
                  ),
                  activeTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: YIoTTheme.fontH3(context),
                  ),
                  items: MainMenu.items,
                  selectedRoute: routeData,
                  onSelected: (item) {
                    if (item.route != null && item.route != routeData) {
                      Navigator.of(context).pushNamed(item.route!);
                    }
                  },
                  header: Container(
                    color: YIoTTheme.backgroundColor,
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 100,
                            maxWidth: 150,
                          ),
                          child: Image.asset(
                            'assets/images/yiot.png',
                          ),
                        ),
                        Divider(
                          indent: 8.0,
                          endIndent: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: body,
                ),
              );
            }
          }
        },
    );
  }
}

// -----------------------------------------------------------------------------
