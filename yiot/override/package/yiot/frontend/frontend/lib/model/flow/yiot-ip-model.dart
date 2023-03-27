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

import 'package:yiot_portal/model/flow/helpers/yiot-model-base.dart';
import 'package:yiot_portal/model/flow/helpers/yiot-protocols.dart';

class YIoTIpModel extends YIoTFlowComponentBase {
  static const _IP_FIELD = "ip";
  static const _PORT_FIELD = "port";
  static const _PROTOCOL_FIELD = "proto";

  static const _IP_DEFAULT = "127.0.0.1";
  static const _PORT_DEFAULT = 5000;

  late String ip;
  late int port;
  late YIoTIpProtocol protocol;

  YIoTIpModel({
    required String id,
    required YIoTFlowDirection direction,
    this.ip = _IP_DEFAULT,
    this.port = _PORT_DEFAULT,
    this.protocol = YIoTIpProtocol.kTCP,
  }) : super(
          id: id,
          type: YIoTFlowComponent.kFlowComponentIP,
          direction: direction,
          baseName: 'IP',
        );

  @override
  String name() => "${ip}:${port}";

  @override
  Map<String, dynamic> _toJson() => {
        _IP_FIELD: ip,
        _PORT_FIELD: port,
        _PROTOCOL_FIELD: protocol,
      };

  @override
  bool fromJson(Map<String, dynamic> json) {
    try {
      // Get IP
      ip = json[_IP_FIELD];

      // Get Port
      port = json[_PORT_FIELD];

      // Get Protocol
      protocol = YIoTIpProtocol.values
          .firstWhere((e) => e.toString() == json[YIoTIpModel._PROTOCOL_FIELD]);

      return true;
    } catch (_) {}

    return false;
  }

  @override
  bool verify() => true;
}

// -----------------------------------------------------------------------------
