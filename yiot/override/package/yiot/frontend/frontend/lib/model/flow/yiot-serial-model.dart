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

class YIoTSerialModel extends YIoTFlowComponentBase {
  static const _DEVICE_FIELD = "device";
  static const _SPEED_FIELD = "speed";
  static const _FORMAT_FIELD = "format";
  static const _PROTOCOL_FIELD = "proto";

  static const _DEVICE_DEFAULT = "/dev/ttyUSB0";
  static const _SPEED_DEFAULT = 115200;
  static const _FORMAT_DEFAULT = "8-N-1";
  static const _PROTOCOL_DEFAULT = YIoTSerialProtocol.kModbusRTU;

  late String device;
  late int speed;
  late String format;
  late YIoTSerialProtocol protocol;

  YIoTSerialModel({
    required String id,
    required YIoTFlowDirection direction,
    this.device = _DEVICE_DEFAULT,
    this.speed = _SPEED_DEFAULT,
    this.format = _FORMAT_DEFAULT,
    this.protocol = _PROTOCOL_DEFAULT,
  }) : super(
          id: id,
          type: YIoTFlowComponent.kFlowComponentIP,
          direction: direction,
          baseName: 'SERIAL',
        );

  @override
  String name() => wrappedBaseName() + " ${device}";

  @override
  Map<String, dynamic> _toJson() => {
        _DEVICE_FIELD: device,
        _SPEED_FIELD: speed,
        _FORMAT_FIELD: format,
        _PROTOCOL_FIELD: protocol,
      };

  @override
  bool fromJson(Map<String, dynamic> json) {
    try {
      // Get Device
      device = json[_DEVICE_FIELD];

      // Get Speed
      speed = json[_SPEED_FIELD];

      // Get Format
      format = json[_FORMAT_FIELD];

      // Get Protocol
      protocol = YIoTSerialProtocol.values.firstWhere(
          (e) => e.toString() == json[YIoTSerialModel._PROTOCOL_FIELD]);

      return true;
    } catch (_) {}

    return false;
  }

  @override
  bool verify() => true;
}

// -----------------------------------------------------------------------------
