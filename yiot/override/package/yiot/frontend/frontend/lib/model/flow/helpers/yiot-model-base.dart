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

// ---------------------------------------------------------------------------
//
//  YIoT Flow IP component direction
//
enum YIoTFlowDirection {
  kInput,
  kOutput,

  kMiddle,
}

// ---------------------------------------------------------------------------
//
//  YIoT Flow IP Protocols enumeration
//
enum YIoTFlowComponent {
  kFlowComponentIP,
  kFlowComponentSerial,

  kFlowComponentNAT,
}

// ---------------------------------------------------------------------------
//
//  YIoT Flow component model
//
abstract class YIoTFlowComponentBase {
  static const YIOT_COMPONENT_ID_FIELD = "id";
  static const YIOT_COMPONENT_TYPE_FIELD = "type";
  static const YIOT_COMPONENT_DIRECTION_FIELD = "direction";

  late final String id;
  late final YIoTFlowComponent type;
  late final YIoTFlowDirection direction;
  late final String baseName;

  YIoTFlowComponentBase({
    required this.id,
    required this.type,
    required this.direction,
    required this.baseName,
  });

  // Abstract functions
  Map<String, dynamic> toMapInternal();
  bool fromJson(Map<String, dynamic> json);
  bool verify();
  String name();

  // Convert to Json
  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {
      YIOT_COMPONENT_ID_FIELD: id,
      YIOT_COMPONENT_TYPE_FIELD: type.toString(),
      YIOT_COMPONENT_DIRECTION_FIELD: direction.toString(),
    };

    res.addAll(toMapInternal());

    return res;
  }

  // Wrapped base name
  String wrappedBaseName() => '[' + baseName + ']';
}

// -----------------------------------------------------------------------------
