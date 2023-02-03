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

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:yiot_portal/components/ui/yiot-dropdown.dart';
import 'package:yiot_portal/components/ui/yiot-file-picker.dart';

// -----------------------------------------------------------------------------

class YIoTServiceParamsWidget extends StatefulWidget {
  late final showLoginPass;
  late final showAccessibility;
  late final showVpnConfig;

  YIoTServiceParamsWidget(
      {this.showLoginPass = true,
      this.showAccessibility = false,
      this.showVpnConfig = false});

  _YIoTServiceParamsWidgetState? state;

  @override
  State<YIoTServiceParamsWidget> createState() {
    state = new _YIoTServiceParamsWidgetState(
        showLoginPass: showLoginPass,
        showAccessibility: showAccessibility,
        showVpnConfig: showVpnConfig);
    return state!;
  }

  String user() {
    return state?.user ?? "admin";
  }

  String password() {
    return state?.password ?? "admin";
  }

  String vpnConfig() {
    if (state != null &&
        state!.vpnConfigSize > 0 &&
        state!.vpnConfigData != null) {
      return utf8.decode(state!.vpnConfigData!);
    }
    return "";
  }

  bool availableViaVPN() {
    return true;
  }

  bool availableViaCloud() {
    return true;
  }
}

class _YIoTServiceParamsWidgetState extends State<YIoTServiceParamsWidget> {
  late final showLoginPass;
  late final showAccessibility;
  late final showVpnConfig;

  static const _space = 10.0;
  double _componentWidth = 350.0;
  String user = "";
  String password = "";
  bool availVPN = false;
  bool availCloud = false;
  String vpnConfigName = "";
  int vpnConfigSize = 0;
  List<int>? vpnConfigData;

  _YIoTServiceParamsWidgetState(
      {required this.showLoginPass,
      required this.showAccessibility,
      required this.showVpnConfig});

  @override
  Widget build(BuildContext context) {
    var components = <Widget>[
      const SizedBox(height: _space),
    ];

    if (showLoginPass) {
      components.add(
        SizedBox(
          width: _componentWidth,
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter username',
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            onChanged: (val) {
              this.setState(() {
                this.user = val;
              });
            },
          ),
        ),
      );

      components.add(
        const SizedBox(height: _space),
      );

      components.add(
        SizedBox(
          width: _componentWidth,
          child: TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter password',
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            onChanged: (val) {
              this.setState(() {
                this.password = val;
              });
            },
          ),
        ),
      );

      components.add(
        const SizedBox(height: _space),
      );
    }

    if (showAccessibility) {
      components.add(const SizedBox(height: _space));

      components.add(
        SizedBox(
          width: _componentWidth,
          child: YIoTDropDown(
            items: [
              'Available in cloud and via VPN',
              'Available via VPN only',
              'Available in cloud only'
            ],
            onChanged: (index) {
              switch (index) {
                case 0:
                  {
                    availVPN = true;
                    availCloud = true;
                    break;
                  }
                case 1:
                  {
                    availVPN = true;
                    availCloud = false;
                    break;
                  }
                case 2:
                  {
                    availVPN = false;
                    availCloud = true;
                    break;
                  }
                default:
                  {
                    availVPN = false;
                    availCloud = false;
                  }
              }
            },
          ),
        ),
      );

      components.add(
        const SizedBox(height: _space),
      );
    }

    if (showVpnConfig) {
      components.add(const SizedBox(height: _space));

      components.add(
        SizedBox(
          width: _componentWidth,
          child: YIoTFilePicker(
            welcomeText: 'Choose VPN configuration file',
            extensions: ['conf'],
            onFileSelected: (name, size, data) {
              vpnConfigName = name;
              vpnConfigSize = size;
              vpnConfigData = data;
            },
          ),
        ),
      );

      components.add(
        const SizedBox(height: _space),
      );
    }

    return Padding(
      padding: EdgeInsets.all(_space),
      child: Column(
        children: components,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
