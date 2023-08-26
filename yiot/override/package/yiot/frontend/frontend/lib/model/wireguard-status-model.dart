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

class WgStatusModel {
  static const _FIELD_NAME = "name";
  static const _FIELD_PUBLIC_KEY = "public_key";
  static const _FIELD_TX = "transfer_tx";
  static const _FIELD_RX = "transfer_rx";

  static const _SECTION_PEERS = "peers";
  static const _FIELD_ENDPOINT = "endpoint";
  static const _FIELD_SERVER_PUBLIC_KEY = "public_key";
  static const _FIELD_LAST_HANDSHAKE = "latest_handshake";
  static const _FIELD_ALLOWED_IPS = "allowed_ips";

  late final bool valid;
  late final String name;
  late final String clientPublicKey;
  late final String serverPublicKey;
  late final int tx;
  late final int rx;
  late final String endpoint;
  late final List<String> allowedIPs;
  late final String latestHandshake;

  WgStatusModel({
    required this.valid,
    required this.name,
    required this.clientPublicKey,
    required this.endpoint,
    required this.latestHandshake,
    required this.rx,
    required this.tx,
    required this.allowedIPs,
    required this.serverPublicKey,
  });

  void show() {
    if (!valid) {
      print('WireGuard VPN Client information is invalid');
      return;
    }
    print("-------- ${this.name} --------");
    print("CLIENT PUBLIC KEY : ${this.clientPublicKey}");
    print("SERVER PUBLIC KEY : ${this.serverPublicKey}");
    print("SERVER ENDPOINT   : ${this.endpoint}");
    print("LATEST HANDSHAKE  : ${this.latestHandshake}");
    print("ALLOWED IPS       : ${this.allowedIPs}");
    print("TX                : ${this.tx}");
    print("RX                : ${this.rx}");
  }

  static WgStatusModel fromJson(dynamic info) {
    try {
      final server = info[_SECTION_PEERS][0];
      final jsonAr = server[_FIELD_ALLOWED_IPS];
      var a = <String>[];
      for (var i = 0; i < jsonAr.length; i++) {
        a.add(jsonAr[i]);
      }

      return WgStatusModel(
        valid: true,
        name: info[_FIELD_NAME],
        clientPublicKey: info[_FIELD_PUBLIC_KEY],
        rx: int.parse(server[_FIELD_RX]),
        tx: int.parse(server[_FIELD_TX]),
        endpoint: server[_FIELD_ENDPOINT],
        latestHandshake: server[_FIELD_LAST_HANDSHAKE],
        serverPublicKey: server[_FIELD_SERVER_PUBLIC_KEY],
        allowedIPs: a,
      );
    } catch (_) {
      return WgStatusModel.invalid();
    }
  }

  //
  //  Return Invalid VPN Client configuration
  //
  static WgStatusModel invalid() {
    return WgStatusModel(
      valid: false,
      name: "",
      clientPublicKey: "",
      endpoint: "",
      latestHandshake: "",
      rx: 0,
      tx: 0,
      allowedIPs: <String>[],
      serverPublicKey: "",
    );
  }
}

// -----------------------------------------------------------------------------
