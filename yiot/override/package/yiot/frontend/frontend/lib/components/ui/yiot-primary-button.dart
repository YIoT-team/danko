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

import 'package:yiot_portal/theme/theme.dart';
import 'package:yiot_portal/utils/responsive-layout.dart';

// -----------------------------------------------------------------------------

class YIoTPrimaryButton extends StatelessWidget {
  final String text;
  VoidCallback? onPressed;
  late final double width;
  late final double height;

  YIoTPrimaryButton(
      {required this.text, this.onPressed, this.width = 150, this.height = 40});

  @override
  Widget build(BuildContext context) {
    var w = ResponsiveLayout.fixGeometrySz(context, width);
    var h = ResponsiveLayout.fixGeometrySz(context, height);
    var e = ResponsiveLayout.fixGeometrySz(context, 15);
    var p = ResponsiveLayout.fixGeometrySz(context, 15);
    return SizedBox(
      width: w,
      height: h,
      child: ElevatedButton(
        // style: ElevatedButton.styleFrom(),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: YIoTTheme.fontH3(context)),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(e),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: p, right: p)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shadowColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(h / 2),
              side: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
