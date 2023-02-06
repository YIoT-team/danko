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
import 'package:yiot_portal/components/ui/yiot-primary-button.dart';
import 'package:yiot_portal/components/ui/yiot-secondary-button.dart';

// -----------------------------------------------------------------------------

class YIoTCommunicatorWidget extends StatefulWidget {
 final textStream;

  const YIoTCommunicatorWidget(
      {required this.textStream, Key? key})
      : super(key: key);

  @override
  State<YIoTCommunicatorWidget> createState() => _YIoTCommunicatorWidgetState(
       textStream: textStream,
      );
}

class _YIoTCommunicatorWidgetState extends State<YIoTCommunicatorWidget> {
  static const _space = 10.0;
  final textStream;
  late TextEditingController _controller;
  ScrollController _scrollController = ScrollController();

  _YIoTCommunicatorWidgetState({required this.textStream});

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
   try {
     textStream.listen((data) {
       _controller.text += "\n" + String.fromCharCodes(data);
       Future.delayed(const Duration(milliseconds: 500), () {
         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
       });
     });
   } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_space),
      child: Column(
        children: [
          const SizedBox(height: _space),
          TextField(
            keyboardType: TextInputType.multiline,
            controller: _controller,
            scrollController: _scrollController,
            readOnly: true,
            maxLines: 25,
            decoration: InputDecoration(
              hintText: "Communication data",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
