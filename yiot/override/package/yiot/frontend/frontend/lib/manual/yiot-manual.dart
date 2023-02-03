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
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

import 'package:pdf/widgets.dart';
import 'package:yiot_portal/model/yiot-manufacturing-info.dart';

// -----------------------------------------------------------------------------

Widget PaddedText(
    final String text, {
      final TextAlign align = TextAlign.left,
    }) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );

class YIoTManual {
  // ---------------------------------------------------------------------------
  //
  //  Create manual page
  //
  static Future<void> create(YIoTManufacturingInfo data) async {
    final imageLogo = MemoryImage((await rootBundle.load(data.icon)).buffer.asUint8List());
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        data.license.deviceInfo.model,
                        style: Theme.of(context).header0.copyWith(
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        data.license.deviceInfo.manufacturer,
                        style: Theme.of(context).header1.copyWith(
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(imageLogo),
                  )
                ],
              ),
              Container(height: 10),
              Divider(
                height: 1,
                borderStyle: BorderStyle.solid,
              ),
              Container(height: 30),
              Table(
                border: TableBorder.all(color: PdfColors.white),
                children: [
                  TableRow(
                    children: [
                      PaddedText('Serial number'),
                      PaddedText(data.license.deviceInfo.serial),
                    ],
                  ),
                  TableRow(
                    children: [
                      PaddedText('MAC address'),
                      PaddedText(data.license.deviceInfo.macAddress),
                    ],
                  ),
                  TableRow(
                    children: [
                      PaddedText('Initial IP address'),
                      PaddedText(data.license.deviceInfo.initialAddress),
                    ],
                  ),
                  TableRow(
                    children: [
                      PaddedText('User'),
                      PaddedText(data.license.deviceInfo.initialUser),
                    ],
                  ),
                  TableRow(
                    children: [
                      PaddedText('Initial password'),
                      PaddedText(data.license.deviceInfo.initialPassword),
                    ],
                  ),
                ],
              ),
              Container(height: 30),
              Row(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Online documentation',
                            style: Theme.of(context).header1.copyWith(
                              fontStyle: FontStyle.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      Container(height: 20),
                      BarcodeWidget(
                        data: data.docLink,
                        barcode: Barcode.qrCode(),
                        color: PdfColors.black,
                        width: 150,
                        height: 150,
                      ),
                    ],
                  ),
                  Container(width: 150),
                  Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Public key',
                            style: Theme.of(context).header1.copyWith(
                              fontStyle: FontStyle.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      Container(height: 20),
                      BarcodeWidget(
                        data: data.license.deviceInfo.publicKey,
                        barcode: Barcode.qrCode(),
                        color: PdfColors.black,
                        width: 150,
                        height: 150,
                      ),
                    ],
                  ),
                ],
              ),


              Container(height: 30),
              Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  data.explain,
                  style: Theme.of(context).header3.copyWith(
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          );
        },
      ),
    );

    final file = File('/Users/kutashenko/Work/yiot/example.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}

// -----------------------------------------------------------------------------
