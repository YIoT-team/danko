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

import 'package:yiot_portal/model/flow/yiot-ip-model.dart';

import 'package:validators/validators.dart';

// -----------------------------------------------------------------------------

typedef OnIpParamUpdated = void Function(YIoTIpModel model);

// -----------------------------------------------------------------------------

class YIoTIpParams extends StatelessWidget {
  late YIoTIpModel model;
  late OnIpParamUpdated onUpdate;

  static const _space = 10.0;
  double _componentWidth = 350.0;

  YIoTIpParams({
    super.key,
    required this.model,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {

    final _controllerIp = TextEditingController(text: model.ip);
    final _controllerPort = TextEditingController(text: model.port.toString());

    return Padding(
      padding: EdgeInsets.all(_space),
      child: Column(
        children: [
          SizedBox(
            width: _componentWidth,
            child: TextFormField(
              controller: _controllerIp,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'IP address',
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'IP address is required';
                }

                if (!isIP(value, 4)) {
                  return 'IP address is not correct';
                }

                return null;
              },
              onChanged: (val) {
                model.ip = val;
                onUpdate(model);
              },
            ),
          ),
          const SizedBox(height: _space),
          SizedBox(
            width: _componentWidth,
            child: TextFormField(
              controller: _controllerPort,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Port',
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Port is required';
                }

                if (!isInt(value)) {
                  return 'Port should be an integer';
                }

                return null;
              },
              onChanged: (val) {
                model.port = int.parse(val);
                onUpdate(model);
              },
            ),
          ),
          const SizedBox(height: _space),
          SizedBox(
            width: _componentWidth,
            child: YIoTDropDown(
              index: model.protocol.index,
              items: [
                'TCP',
                'UDP',
                'RTSP',
                'Modbus TCP',
                'Other',
              ],
              onChanged: (index) {
                model.protocol = YIoTIpProtocol.values.elementAt(index);
                onUpdate(model);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
