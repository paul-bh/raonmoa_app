import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:raonmoa_app/BH_touchFX/bh_touchfx.dart';
import 'package:raonmoa_app/logics/design.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

Widget homeSquareCard({String? title, Widget? child, bool isStacked = true, double ratio = 1.0, VoidCallback? onTap}) {
  return AspectRatio(
    aspectRatio: ratio,
    child: Card(
      margin: EdgeInsets.all(6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        side: BorderSide(color: $raonmoaColor, width: 1.0),
      ),
      color: Colors.white,
      elevation: 0,
      child: BHTouchFXInkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        $clickedColor: $raonmoaColor.withOpacity(0.1),
        $clickedRadius: 30.0,
        $clickedShrinkRatio: 0.005,
        $clickedCurveSizeIn: Curves.easeOutCirc,
        $clickedCurveSizeOut: Curves.easeOutCirc,
        $clickedDurationIn: Duration(milliseconds: 100),
        $clickedDurationOut: Duration(milliseconds: 200),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: isStacked
                  //* NOTE 메인 위젯의 제목과 겹쳐서 배치되어야 할 경우
                  ? Stack(children: [
                      Text(title ?? "", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      Container(
                        child: child ?? Container(),
                        width: double.infinity,
                        height: double.infinity,
                      )
                    ])
                  //* NOTE 메인 위젯의 제목 아래에 배치되어야 할 경우
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(title ?? "#", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                        if (child != null) Expanded(child: child) else Container(),
                      ],
                    ),
            ),
            // add a arrow icon to the top right corner
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.arrow_forward_ios, size: 16.0, color: $raonmoaColor),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// code and corresponding title into map
Map widgetData = {
  "waterTemp": {"title": "수온"},
  "temp": {"title": "온도"},
  "humidity": {"title": "습도"},
  "CO": {"title": "CO"},
  "CO2": {"title": "CO2"},
  "pH": {"title": "pH"},
  "TVOC": {"title": "TVOC"},
  "waterLevel": {"title": "수위"},
  "fineDust": {"title": "미세먼지"},
  "ultraFineDust": {"title": "초미세먼지"},
};

class FractionalClipper extends CustomClipper<Rect> {
  double fraction;
  FractionalClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0,
      size.height * fraction,
      size.width,
      size.height * (1 - fraction),
    );
  }

  @override
  bool shouldReclip(FractionalClipper oldClipper) => fraction != oldClipper.fraction;
}
