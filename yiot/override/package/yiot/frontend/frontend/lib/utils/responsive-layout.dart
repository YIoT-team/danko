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

 class ResponsiveLayout {

   static bool isSmallScreen(BuildContext context) {
     return MediaQuery.of(context).size.width < 800 || MediaQuery.of(context).size.height < 640;
   }

   static bool isMediumScreen(BuildContext context) {
     return MediaQuery.of(context).size.width > 800 &&
         MediaQuery.of(context).size.width < 1200 && MediaQuery.of(context).size.height > 640;
   }

   static bool isLargeScreen(BuildContext context) {
     return MediaQuery.of(context).size.width > 1200 && MediaQuery.of(context).size.height > 640;
   }

   static double fixFontSz(BuildContext context, double sz) {
     if (isSmallScreen(context)) {
       return sz / 2;
     }

     if (isMediumScreen(context)) {
       return sz * 3 / 4;
     }
     return sz;
   }

   static double fixPaddingSz(BuildContext context, double sz) {
     if (isSmallScreen(context)) {
       return sz / 2;
     }

     if (isMediumScreen(context)) {
       return sz * 3 / 4;
     }
     return sz;
   }

   static double fixGeometrySz(BuildContext context, double sz) {
     if (isSmallScreen(context)) {
       return sz * 3 / 4;
     }

     if (isMediumScreen(context)) {
       return sz * 5 / 6;
     }
     return sz;
   }

 }
