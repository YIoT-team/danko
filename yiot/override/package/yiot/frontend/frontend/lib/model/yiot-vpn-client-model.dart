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

import 'package:ini/ini.dart';

class YIoTVpnClientModel {
  static const _SECTION_INTERFACE = "Interface";
  static const _FIELD_ADDRESS = "Address";
  static const _FIELD_PRIVATE_KEY = "PrivateKey";

  static const _SECTION_PEER = "Peer";
  static const _FIELD_PUBLIC_KEY = "PublicKey";
  static const _FIELD_PRESHARED_KEY = "PresharedKey";
  static const _FIELD_ALLOWED_IPS = "AllowedIPs";
  static const _FIELD_ENDPOINT = "Endpoint";
  static const _FIELD_KEEPALIVE = "PersistentKeepalive";

  final String protocol = 'wireguard';

  late final bool valid;
  late final String interfaceName;
  late final String networkName;
  late final String description;
  late final String publicKey;
  late final String presharedKey;
  late final String allowedIPs;
  late final String keepAliveInterval;
  late final String endpointHost;
  late final String endpointPort;
  late final String privateKey;
  late final String addresses;

  YIoTVpnClientModel({
    required this.valid,
    required this.interfaceName,
    required this.networkName,
    required this.description,
    required this.publicKey,
    required this.presharedKey,
    required this.allowedIPs,
    required this.keepAliveInterval,
    required this.endpointHost,
    required this.endpointPort,
    required this.privateKey,
    required this.addresses,
  });

  void show() {
    if (!valid) {
      print('VPN Client configuration is invalid');
      return;
    }
    print("-------- ${this.description} --------");
    print("NETWORK NAME    : ${this.networkName}");
    print("INTERFACE NAME  : ${this.interfaceName}");
    print("PUBLIC KEY      : ${this.publicKey}");
    print("PRE SHARED KEY  : ${this.presharedKey}");
    print("ALLOWED IPS     : ${this.allowedIPs}");
    print("KEEPALIVE       : ${this.keepAliveInterval}");
    print("ENDPOINT HOST   : ${this.endpointHost}");
    print("ENDPOINT PORT   : ${this.endpointPort}");
    print("PRIVATE KEY     : ${this.privateKey}");
    print("ADDRESSES       : ${this.addresses}");
  }

  static YIoTVpnClientModel fromConf(String name, String config) {

    final conf = Config.fromString(config);

    //
    //  Parse Interface section
    //
    final addr = conf.get(_SECTION_INTERFACE, _FIELD_ADDRESS);
    if (addr == null) {
      return YIoTVpnClientModel.invalid();
    }

    final privKey = conf.get(_SECTION_INTERFACE, _FIELD_PRIVATE_KEY);
    if (privKey == null) {
      return YIoTVpnClientModel.invalid();
    }

    //
    //  Parse Peer section
    //
    final pubKey = conf.get(_SECTION_PEER, _FIELD_PUBLIC_KEY);
    if (pubKey == null) {
      return YIoTVpnClientModel.invalid();
    }

    final presharedKey = conf.get(_SECTION_PEER, _FIELD_PRESHARED_KEY);
    if (presharedKey == null) {
      return YIoTVpnClientModel.invalid();
    }

    final allowedIPs = conf.get(_SECTION_PEER, _FIELD_ALLOWED_IPS);
    if (allowedIPs == null) {
      return YIoTVpnClientModel.invalid();
    }

    final endpoint = conf.get(_SECTION_PEER, _FIELD_ENDPOINT);
    if (endpoint == null) {
      return YIoTVpnClientModel.invalid();
    }

    final keepalive = conf.get(_SECTION_PEER, _FIELD_KEEPALIVE);
    if (keepalive == null) {
      return YIoTVpnClientModel.invalid();
    }

    // Parse Endpoint Host:Port
    final l = endpoint.split(':');
    final host = l[0];
    var port = '';
    if (l.length >= 2) {
      port = l[1];
    }

    // Prepare Interface name
    final p = name.split('.');
    final interfaceName = 'wg_' + p[0].replaceAll('-', '_').toLowerCase();

    // Return parsed configuration

    return YIoTVpnClientModel(
      valid: true,
      interfaceName: interfaceName,
      networkName: 'wireguard_' + interfaceName,
      description: name,
      publicKey: pubKey,
      presharedKey: presharedKey,
      allowedIPs: allowedIPs,
      keepAliveInterval: keepalive,
      endpointHost: host,
      endpointPort: port,
      privateKey: privKey,
      addresses: addr,
    );

  }


  //
  //  Return Invalid VPN Client configuration
  //
  static YIoTVpnClientModel invalid() {
    return YIoTVpnClientModel(
      valid: false,
      interfaceName: '',
      networkName: '',
      description: '',
      publicKey: '',
      presharedKey: '',
      allowedIPs: '',
      keepAliveInterval: '',
      endpointHost: '',
      endpointPort: '',
      privateKey: '',
      addresses: '',
    );
  }
}

// -----------------------------------------------------------------------------
