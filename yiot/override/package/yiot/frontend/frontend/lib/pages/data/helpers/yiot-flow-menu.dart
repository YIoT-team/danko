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

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:yiot_portal/components/ui/yiot-icons.dart';
import 'package:yiot_portal/controllers/yiot-flow-controller.dart';

class YIoTFlowMenu {
  static List<AdminMenuItem> items = [
    //
    //  Inputs
    //
    AdminMenuItem(
      title: 'Inputs',
      icon: Icons.input,
      children: [
        AdminMenuItem(
          title: 'IP : Port',
          icon: YIoTIcons.ethernet,
          route: YIoTFlowAction.addInputIpPort.toString(),
        ),
        AdminMenuItem(
          title: 'Serial',
          icon: Icons.settings_ethernet,
          route: YIoTFlowAction.addInputSerial.toString(),
        ),
      ],
    ),

    //
    //  Outputs
    //
    AdminMenuItem(
      title: 'Outputs',
      icon: Icons.output,
      children: [
        AdminMenuItem(
          title: 'IP : Port',
          icon: YIoTIcons.ethernet,
          route: YIoTFlowAction.addOutputIpPort.toString(),
        ),
        AdminMenuItem(
          title: 'Serial',
          icon: Icons.settings_ethernet,
          route: YIoTFlowAction.addOutputSerial.toString(),
        ),
      ],
    ),

    //
    //  Processing
    //
    AdminMenuItem(
      title: 'Processing',
      icon: Icons.screen_rotation_alt,
      children: [
        AdminMenuItem(
          title: 'Forwarding',
          icon: YIoTIcons.forward,
          route: YIoTFlowAction.addProcessingForwarding.toString(),
        ),
      ],
    ),

    //
    //  Save
    //
    AdminMenuItem(
      title: 'Save',
      icon: Icons.save,
      route: YIoTFlowAction.operationSave.toString(),
    ),

    //
    //  Download
    //
    AdminMenuItem(
      title: 'Download',
      icon: Icons.save_alt,
      route: YIoTFlowAction.operationDownload.toString(),
    ),

    //
    //  Upload
    //
    AdminMenuItem(
      title: 'Upload',
      icon: Icons.upload_file,
      route: YIoTFlowAction.operationUpload.toString(),
    ),
  ];
}

// -----------------------------------------------------------------------------
