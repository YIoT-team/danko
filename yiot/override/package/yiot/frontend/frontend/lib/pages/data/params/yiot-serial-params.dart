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

import 'package:yiot_portal/components/ui/yiot-dropdown.dart';
import 'package:yiot_portal/model/flow/helpers/yiot-protocols.dart';

import 'package:yiot_portal/model/flow/yiot-serial-model.dart';

import 'package:validators/validators.dart';

// -----------------------------------------------------------------------------

typedef OnSerialParamUpdated = void Function(YIoTSerialModel model);

// -----------------------------------------------------------------------------

class YIoTSerialParams extends StatelessWidget {
  late YIoTSerialModel model;
  late OnSerialParamUpdated onUpdate;

  static const _space = 10.0;
  double _componentWidth = 350.0;

  YIoTSerialParams({
    super.key,
    required this.model,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_space),
      child: Column(
        children: [
          SizedBox(
            width: _componentWidth,
            child: YIoTDropDown(
              index: 0,
              items: [
                'ttyUSB0',
              ],
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: _space),
          SizedBox(
            width: _componentWidth,
            child: YIoTDropDown(
              index: 1,
              items: [
                '9600',
                '115200',
              ],
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: _space),
          SizedBox(
            width: _componentWidth,
            child: YIoTDropDown(
              index: 0,
              items: [
                '8-N-1',
              ],
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: _space),
          SizedBox(
            width: _componentWidth,
            child: YIoTDropDown(
              index: model.protocol.index,
              items: [
                'Modbus RTU',
                'Modbus ASCII',
                'Other',
              ],
              onChanged: (index) {
                model.protocol = YIoTSerialProtocol.values.elementAt(index);
                onUpdate(model);
              },
            ),
          ),
          const SizedBox(height: _space),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
