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
import 'package:toggle_switch/toggle_switch.dart';

typedef OnIndexChanged = void Function(int index);

// -----------------------------------------------------------------------------
class YIoTDropDown extends StatefulWidget {
  List<String> items;
  OnIndexChanged onChanged;
  _YIoTDropDownState? state;

  YIoTDropDown({required this.items, required this.onChanged});

  @override
  State<YIoTDropDown> createState() {
    if (state == null) {
      state = new _YIoTDropDownState(items: items, onChanged: onChanged);
    }
    return state!;
  }

  int currentValue() {
    return state?.currentIndex ?? -1;
  }
}

class _YIoTDropDownState extends State<YIoTDropDown> {
  List<String> items;
  OnIndexChanged onChanged;

  int currentIndex = 0;
  Color _color = Colors.grey;

  _YIoTDropDownState({required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: items.elementAt(currentIndex),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      isExpanded: true,
      style: TextStyle(color: _color, fontSize: 16.0),
      underline: Container(
        height: 1,
        color: _color,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          currentIndex = items.indexOf(value!);
        });
        onChanged(currentIndex);
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// -----------------------------------------------------------------------------
