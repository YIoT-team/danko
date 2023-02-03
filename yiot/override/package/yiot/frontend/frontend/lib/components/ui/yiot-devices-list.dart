// //  ────────────────────────────────────────────────────────────
// //                     ╔╗  ╔╗ ╔══╗      ╔════╗
// //                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
// //                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
// //                      ╚╗╔╝   ║║  ║╔╗║   ║║
// //                       ║║   ╔╣╠╗ ║╚╝║   ║║
// //                       ╚╝   ╚══╝ ╚══╝   ╚╝
// //    ╔╗╔═╗                    ╔╗                     ╔╗
// //    ║║║╔╝                   ╔╝╚╗                    ║║
// //    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
// //    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
// //    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
// //    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
// //                    ║║                         ║║
// //                    ╚╝                         ╚╝
// //
// //    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
// //  ────────────────────────────────────────────────────────────
// import 'dart:html' as html;
// import 'package:flutter/material.dart';
//
// import 'package:yiot_portal/components/ui/yiot-secondary-button.dart';
//
// import 'package:yiot_portal/api/response/service-virtual-device.dart';
//
// typedef OnDeleteRequest = void Function(int id);
//
// // -----------------------------------------------------------------------------
//
// class YIoTDevicesList extends StatelessWidget {
//   final List<YIoTVDevInfoModel> devices;
//   final OnDeleteRequest? onDeleteRequest;
//
//   YIoTDevicesList({required this.devices, this.onDeleteRequest});
//
//   IconData _iconByType(String type) {
//     if (type == "lamp") {
//       return Icons.lightbulb;
//     }
//
//     if (type == "lock") {
//       return Icons.lock;
//     }
//
//     return Icons.device_unknown;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double _HEIGHT = 40;
//     return Table(
//       border: TableBorder(
//           horizontalInside: BorderSide(
//               width: 1, color: Colors.black12, style: BorderStyle.solid)),
//       children: List<TableRow>.generate(
//         devices.length,
//         (index) {
//           final device = devices[index];
//           return TableRow(
//             children: [
//               SizedBox(
//                 height: _HEIGHT,
//                 child: Icon(
//                   _iconByType(device.type),
//                 ),
//               ),
//               SizedBox(
//                 height: _HEIGHT,
//                 child: Center(
//                   child: Text("01:02:03:04:05:AA", textAlign: TextAlign.center),
//                 ),
//               ),
//               IconButton(
//                 iconSize: 32,
//                 splashRadius: 22,
//                 icon: Icon(
//                   Icons.remove_red_eye_outlined,
//                   color: Colors.blueAccent,
//                 ),
//                 onPressed: () {
//                   html.window.open(device.url, device.id.toString());
//                 },
//               ),
//               IconButton(
//                 iconSize: 32,
//                 splashRadius: 22,
//                 icon: Icon(
//                   Icons.restart_alt,
//                   color: Colors.blueAccent,
//                 ),
//                 onPressed: () {
//                   // html.window.open(device.url, device.id.toString());
//                 },
//               ),
//               IconButton(
//                 iconSize: 32,
//                 splashRadius: 22,
//                 icon: Icon(
//                   Icons.delete_forever,
//                   color: Colors.redAccent,
//                 ),
//                 onPressed: () {
//                   if (onDeleteRequest != null) {
//                     onDeleteRequest!(device.id);
//                   }
//                 },
//               ),
//             ],
//           );
//         },
//         growable: false,
//       ),
//     );
//   }
// }
//
// // -----------------------------------------------------------------------------
