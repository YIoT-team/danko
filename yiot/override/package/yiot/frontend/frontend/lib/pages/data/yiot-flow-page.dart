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
import 'package:yiot_portal/model/flow/yiot-ip-model.dart';
import 'package:yiot_portal/model/flow/yiot-nat-model.dart';
import 'package:yiot_portal/model/flow/yiot-serial-model.dart';
import 'package:yiot_portal/pages/data/helpers/yiot-flow-menu.dart';

import 'package:yiot_portal/pages/data/params/yiot-ip-params.dart';
import 'package:yiot_portal/pages/data/params/yiot-serial-params.dart';
import 'package:yiot_portal/pages/data/params/yiot-nat-params.dart';
import 'package:yiot_portal/pages/data/params/yiot-params-editor.dart';
import 'package:yiot_portal/pages/data/params/yiot-connection-editor.dart';

import 'package:yiot_portal/model/flow/helpers/yiot-model-base.dart';
import 'package:flutter_flow_chart/flutter_flow_chart.dart';
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
  late final YIoTFlowController _flowController;
  YIoTFlowComponentBase? selectedElement;
  Handler? selectedConnection;
  FlowElement? selectedConnectionOwner;

  _DataFlowPageState() {
    _flowController = YIoTFlowController(dashboard: _dashboard);
  }

  @override
  Widget build(BuildContext context) {
    const _mobileThreshold = 768.0;
    final isMobile = MediaQuery.of(context).size.width < _mobileThreshold;
    AppBar? appBar;

    Widget? settings;

    if (selectedElement != null) {
      settings = _settingsForElement(selectedElement!);
    } else if (selectedConnection != null && selectedConnectionOwner != null) {
      settings = YIoTConnectionEditor(
          controller: _flowController,
          element: selectedConnectionOwner!,
          handler: selectedConnection!);
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
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 2000,
                  width: 2000,
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: FlowChart(
                      dashboard: _dashboard,
                      onDashboardTapped: ((context, position) {
                        setState(() {
                          selectedElement = null;
                          selectedConnection = null;
                          selectedConnectionOwner = null;
                        });
                      }),
                      onElementPressed: (context, position, element) {
                        setState(() {
                          selectedElement =
                              _flowController.getModel(element.id);
                          selectedConnection = null;
                          selectedConnectionOwner = null;
                        });
                      },
                      onHandlerPressed: (context, position, handler, element) {
                        setState(() {
                          selectedElement = null;
                          selectedConnection = handler;
                          selectedConnectionOwner = element;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(child: settings),
          ],
        ),
      ),
    );
  }

  Widget? _settingsForElement(YIoTFlowComponentBase selectedElement) {
    Widget? body;

    // Settings for IP : Port
    if (selectedElement.type == YIoTFlowComponent.kFlowComponentIP) {
      body = YIoTIpParams(
        model: selectedElement! as YIoTIpModel,
        onUpdate: (model) {
          _flowController.update(model);
        },
      );
    }

    // Settings for Serial
    if (selectedElement.type == YIoTFlowComponent.kFlowComponentSerial) {
      body = YIoTSerialParams(
        model: selectedElement! as YIoTSerialModel,
        onUpdate: (model) {
          _flowController.update(model);
        },
      );
    }

    // Settings for NAT
    if (selectedElement.type == YIoTFlowComponent.kFlowComponentNAT) {
      body = YIoTNatParams(
        model: selectedElement! as YIoTNatModel,
        onUpdate: (model) {
          _flowController.update(model);
        },
      );
    }

    return YIoTParamEditor(
        controller: _flowController,
        model: selectedElement!,
        body: body!,
    );
  }
}
// -----------------------------------------------------------------------------
