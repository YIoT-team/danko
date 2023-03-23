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

import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:yiot_portal/pages/data/helpers/text-menu.dart';
import 'package:yiot_portal/pages/data/helpers/element-settings-menu.dart';
import 'package:yiot_portal/pages/data/helpers/yiot-flow-menu.dart';
import 'package:yiot_portal/pages/data/params/yiot-in-ip-params.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
import 'package:star_menu/star_menu.dart';

import 'package:yiot_portal/controllers/yiot-flow-controller.dart';

import 'package:yiot_portal/theme/theme.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';


// -----------------------------------------------------------------------------
class DataFlowPage extends StatefulWidget {
  DataFlowPage({Key? key}) : super(key: key);

  @override
  _DataFlowPageState createState() => _DataFlowPageState();
}

// -----------------------------------------------------------------------------
class _DataFlowPageState extends State<DataFlowPage> {
  final _dashboard = Dashboard();
  late final _flowController;
  int selectedId = 0;

  _DataFlowPageState() {
    _flowController = YIoTFlowController(dashboard: _dashboard);
  }

  @override
  Widget build(BuildContext context) {
    const _mobileThreshold = 768.0;
    final isMobile = MediaQuery.of(context).size.width < _mobileThreshold;
    AppBar? appBar;

    Widget? settings;

    if (selectedId != 0) {
      print(">>> ADD SETTINGS VIEW");
      settings = YIoTInputIpParams();
      print(settings);
    }

    if (isMobile) {
      appBar = AppBar(
        title: Text("Data flow"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      child: AdminScaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        sideBar: SideBar(
          footer: settings,
          width: 200,
          backgroundColor: Colors.white,
          activeBackgroundColor: Colors.white,
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
          items: YIoTFlowMenu.items,
          selectedRoute: "",
          onSelected: (item) async {
            if (item.route != null) {
              YIoTFlowAction command = YIoTFlowAction.values
                  .firstWhere((e) => e.toString() == item.route!);
              final res = await _flowController.processCommand(command, null);
              if (!res) {
                print("Cannot process : ${item.route!}");
              }
            }
          },
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: 2000,
            width: 2000,
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: FlowChart(
                dashboard: _dashboard,
                onDashboardTapped: ((context, position) {
                  debugPrint('Dashboard tapped $position');
                  setState(() {
                    print(">>> HIDE SETTINGS VIEW");
                    selectedId = 0;
                  });
                }),
                onDashboardLongtTapped: ((context, position) {
                  debugPrint('Dashboard long tapped $position');
                }),
                onElementLongPressed: (context, position, element) {
                  debugPrint('Element with "${element.text}" text '
                      'long pressed');
                },
                onElementPressed: (context, position, element) {
                  debugPrint('Element with "${element.text}" text pressed');
                  // setState(() {
                  //   selectedId = 1;
                  // });
                  _displayElementMenu(context, position, element);
                },
                onHandlerPressed: (context, position, handler, element) {
                  debugPrint('handler pressed: position $position '
                      'handler $handler" of element $element');
                  _displayHandlerMenu(position, handler, element);
                },
                onHandlerLongPressed: (context, position, handler, element) {
                  debugPrint('handler long pressed: position $position '
                      'handler $handler" of element $element');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  //*********************
  //* POPUP MENUS
  //*********************

  /// Display a drop down menu when tapping on a handler
  _displayHandlerMenu(
    Offset position,
    Handler handler,
    FlowElement element,
  ) {
    StarMenuOverlay.displayStarMenu(
      context,
      StarMenu(
        params: StarMenuParameters(
          shape: MenuShape.linear,
          openDurationMs: 60,
          linearShapeParams: const LinearShapeParams(
            angle: 270,
            space: 10,
          ),
          onHoverScale: 1.1,
          useTouchAsCenter: true,
          centerOffset: position -
              Offset(
                _dashboard.dashboardSize.width / 2,
                _dashboard.dashboardSize.height / 2,
              ),
        ),
        onItemTapped: (index, controller) => controller.closeMenu!(),
        items: [
          FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: () =>
                _dashboard.removeElementConnection(element, handler),
          )
        ],
        parentContext: context,
      ),
    );
  }

  /// Display a drop down menu when tapping on an element
  _displayElementMenu(
    BuildContext context,
    Offset position,
    FlowElement element,
  ) {
    StarMenuOverlay.displayStarMenu(
      context,
      StarMenu(
        params: StarMenuParameters(
          shape: MenuShape.linear,
          openDurationMs: 60,
          linearShapeParams: const LinearShapeParams(
            angle: 270,
            alignment: LinearAlignment.left,
            space: 10,
          ),
          onHoverScale: 1.1,
          centerOffset: position - const Offset(50, 0),
          backgroundParams: const BackgroundParams(
            backgroundColor: Colors.transparent,
          ),
          boundaryBackground: BoundaryBackground(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              boxShadow: kElevationToShadow[6],
            ),
          ),
        ),
        onItemTapped: (index, controller) {
          if (!(index == 5 || index == 2)) {
            controller.closeMenu!();
          }
        },
        items: [
          Text(
            element.text,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          InkWell(
            onTap: () => _dashboard.removeElement(element),
            child: const Text('Delete'),
          ),
          TextMenu(element: element),
          InkWell(
            onTap: () {
              _dashboard.removeElementConnections(element);
            },
            child: const Text('Remove all connections'),
          ),
          InkWell(
            onTap: () {
              _dashboard.setElementResizable(element, true);
            },
            child: const Text('Resize'),
          ),
          ElementSettingsMenu(
            element: element,
          ),
        ],
        parentContext: context,
      ),
    );
  }
}
// -----------------------------------------------------------------------------
