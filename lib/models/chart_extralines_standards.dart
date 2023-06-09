import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartExtraLinesStandards {
  static List<HorizontalLine> pm = [
    HorizontalLine(
      y: 30,
      color: Colors.blue.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '0~30ppm, 좋음',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.blue, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 80,
      color: Colors.green.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => ' 31~80ppm, 양호',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.green, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 150,
      color: Colors.orange.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '81~150ppm, 나쁨',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.orange, fontSize: 9),
      ),
    ),
  ];

  static List<HorizontalLine> upm = [
    HorizontalLine(
      y: 15,
      color: Colors.blue.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '0~15ppm, 좋음',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.blue, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 35,
      color: Colors.green.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => ' 16~35ppm, 양호',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.green, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 75,
      color: Colors.orange.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '36~75ppm, 나쁨',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.orange, fontSize: 9),
      ),
    ),
  ];
  static List<HorizontalLine> co = [
    HorizontalLine(
      y: 10,
      color: Colors.blue.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '좋음',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.blue, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 25,
      color: Colors.green.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '보통',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.green, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 50,
      color: Colors.orange.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '주의',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.orange, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 200,
      color: Colors.orange.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '위험',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.red, fontSize: 9),
      ),
    ),
  ];
  static List<HorizontalLine> co2 = [
    HorizontalLine(
      y: 500,
      color: Colors.blue.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '좋음',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.blue, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 1000,
      color: Colors.green.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '보통',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.green, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 2000,
      color: Colors.orange.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '주의',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.orange, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 5000,
      color: Colors.orange.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '위험',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.red, fontSize: 9),
      ),
    ),
  ];

  static List<HorizontalLine> tvoc = [
    HorizontalLine(
      y: 60,
      color: Colors.blue.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '60ppb, 좋음',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.blue, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 200,
      color: Colors.green.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => ' 200ppb, 양호',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.green, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 600,
      color: Colors.orange.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '600ppb, 나쁨',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.orange, fontSize: 9),
      ),
    ),
    HorizontalLine(
      y: 1999,
      color: Colors.red.withOpacity(0.4),
      strokeWidth: 1,
      label: HorizontalLineLabel(
        labelResolver: (p0) => '2000ppb, 심각',
        padding: EdgeInsets.all(4),
        alignment: Alignment.topRight,
        show: true,
        style: TextStyle(color: Colors.red, fontSize: 9),
      ),
    ),

    //
  ];
}
