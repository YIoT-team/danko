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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/spacer-widget.dart';
import '../utils/responsive-layout.dart';

// -----------------------------------------------------------------------------
class YIoTPresentationElement {
  late final String url;
  late final String comment;
  late final int viewTime;

  YIoTPresentationElement(
      {required this.url, required this.comment, this.viewTime = 7});
}

// -----------------------------------------------------------------------------
final List<YIoTPresentationElement> slidesList = [
  YIoTPresentationElement(
    url: "presentation/yiot-1.png",
    comment: "If you have an idea of IoT device ...",
  ),
  YIoTPresentationElement(
    url: "presentation/yiot-2.png",
    comment: "but it requires a lot of components to be created ...",
    viewTime: 10,
  ),
  YIoTPresentationElement(
    url: "presentation/yiot-3.png",
    comment:
        "Your IoT portal is ready to help with implementation of your Idea ...",
  ),
  YIoTPresentationElement(
    url: "presentation/yiot-4.png",
    comment: "here you'll control creation of required components ...",
  ),
  YIoTPresentationElement(
    url: "presentation/yiot-5.png",
    comment:
        "we prepared a lot of open-source modules, freelance teams, OEM companies, manufacturers",
    viewTime: 12,
  ),
  YIoTPresentationElement(
    url: "presentation/yiot-6.png",
    comment: "it'll be a path from an Idea to manufactured device",
  ),
  YIoTPresentationElement(
    url: "presentation/yiot-7.png",
    comment:
        "Also, Your IoT portal helps to Sell documentation and sources for manufacturing, or to make it Free to a whole world.",
    viewTime: 30,
  ),
];

// -----------------------------------------------------------------------------
class YIoTPresentationPage extends StatefulWidget {
  @override
  _YIoTPresentationPageState createState() {
    return new _YIoTPresentationPageState();
  }
}

// -----------------------------------------------------------------------------
class _YIoTPresentationPageState extends State<YIoTPresentationPage> {
  bool autoPlay = true;
  String comment = slidesList[0].comment;
  int delaySec = slidesList[0].viewTime;
  bool underlined = false;
  CarouselController _imagesCarouselController = CarouselController();

  // ---------------------------------------------------------------------------
  List<Widget> _images(double width, double height) {
    // Add all images to presentation
    var l = slidesList
        .map(
          (item) => Container(
            margin: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image.asset(
                  item.url,
                  fit: BoxFit.fill,
                  height: height,
                ),
              ),
            ),
          ),
        )
        .toList();

    var h = height - 20;
    var w = height * 4 / 3;

    if (w >= width) {
      w = width - 20;
      h = w * 3 / 4;
    }

    // Add spacer page
    l.add(
      Container(
        margin: EdgeInsets.all(5.0),
        child: YIoTSpacerWidget(width: w, height: h),
      ),
    );

    return l;
  }

  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var szTotal = MediaQuery.of(context).size.height - 81;
    var szImages = szTotal * 3 / 4;
    var szComments = szTotal * 1 / 4;
    var _items = _images(MediaQuery.of(context).size.width, szImages);

    var fontSz = ResponsiveLayout.fixFontSz(context, underlined ? 36.0 : 30.0);

    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: szComments - 10,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  comment,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arvo(
                    fontSize: fontSz,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: szImages,
            child: CarouselSlider(
              items: _items,
              carouselController: _imagesCarouselController,
              options: CarouselOptions(
                autoPlay: autoPlay,
                autoPlayInterval: Duration(seconds: delaySec),
                enlargeCenterPage: true,
                viewportFraction: 0.95,
                aspectRatio: 4 / 3,
                clipBehavior: Clip.none,
                onPageChanged: (index, reason) {
                  this.setState(() {
                    int edgeIndex = _items.length - 1;
                    autoPlay = index != edgeIndex;
                    underlined = index == edgeIndex;
                    if (index < edgeIndex) {
                      comment = slidesList[index].comment;
                      delaySec = slidesList[index].viewTime;
                    } else {
                      comment = "YIoT team greetings you";
                      delaySec = 0;
                    }
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
