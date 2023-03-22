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

import 'dart:io';
import 'dart:convert';
import 'package:yiot_portal/model/yiot-device.dart';
import 'package:yiot_portal/model/yiot-license.dart';
import 'package:random_password_generator/random_password_generator.dart';

class YIoTProvision {
  // ---------------------------------------------------------------------------
  //
  //  Base directory
  //
  static String _baseDir() {
    Map<String, String> envVars = Platform.environment;

    // Get home directory
    String homeDir = "";
    var h = envVars['HOME'];
    if (h != null) {
      homeDir = h!;
    }
    var baseDir = homeDir + '/yiot';

    // Run Provisioning process
    return baseDir;
  }

  // ---------------------------------------------------------------------------
  //
  //  Start device provision
  //
  static Future<Process> start() async {
    return await Process.start(
        'bash', ['-c', _baseDir() + '/start-yiot-factory-tool.sh']);
  }

  // ---------------------------------------------------------------------------
  //
  //  Process provision artifacts
  //
  static Future<YIoTLicense> processArtifacts() async {
    var res = YIoTLicense.blank();
    var artifacts = File(_baseDir() + '/artifacts/output.txt');

    // Read result file
    var str;
    try {
      final file = await artifacts;

      // Read the file
      var list = await file.readAsLines();
      str = list.last;
    } catch (e) {
      return res;
    }

    // Decode base64
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String jsonText = stringToBase64.decode(str);

    // Parse license JSON
    var j = json.decode(jsonText);

    // Get license data
    String l = stringToBase64.decode(j['license']);
    var licJson = json.decode(l);
    var dataJson = licJson['device'];

    // Parse device info
    var serial = stringToBase64.decode(dataJson['serial']);
    var deviceInfo = YIoTDevice(
        manufacturer: dataJson['manufacturer'],
        model: 'CV-2SE',//dataJson['model'],
        serial: serial,
        macAddress: dataJson['mac'],
        publicKey: dataJson['publicKeyTiny'],
        initialUser: 'yiot',
        initialPassword: RandomPasswordGenerator().randomPassword(
            numbers: true,
            specialChar: true,
            uppercase: true,
            passwordLength: 10),
        initialAddress: '192.168.1.1');

    // Parse license
    var license = YIoTLicense(full: str, deviceInfo: deviceInfo);

    return license;
  }
}

// -----------------------------------------------------------------------------
