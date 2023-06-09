import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:raonmoa_app/BH_touchFX/bh_touchfx.dart';
import 'package:raonmoa_app/logics/design.dart';

class IotControllerTile extends StatelessWidget {
  final String deviceName;
  final String deviceStatus;
  final IconData deviceIcon;
  VoidCallback? onTap;

  IotControllerTile({
    Key? key,
    required this.deviceName,
    required this.deviceStatus,
    required this.deviceIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // change background color to green when ON, red when OFF
    return BHTouchFXInkWell(
      onTap: onTap,
      $clickedColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      $clickedRadius: 30.0,
      $clickedShrinkRatio: 0.05,
      $clickedCurveSizeIn: Curves.easeOutCubic,
      $clickedCurveSizeOut: Curves.easeOutCubic,
      $clickedDurationIn: Duration(milliseconds: 50),
      $clickedDurationOut: Duration(milliseconds: 200),
      child: Container(
        width: 150,
        height: 150,
        padding: EdgeInsets.all(8.0),
        // margin: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          // round the corners and put raonmoa colored border
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: deviceStatus == 'ON'
                ? Colors.green.withOpacity(1)
                : deviceStatus == 'OFF'
                    ? Colors.red.withOpacity(1)
                    : Colors.grey.withOpacity(1),
            width: 1.0,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          // half-transparent rounded background
          decoration: BoxDecoration(
            color: deviceStatus == 'ON'
                ? Color.fromARGB(255, 168, 255, 171)
                : deviceStatus == 'OFF'
                    ? Colors.red.withOpacity(0.35)
                    : Colors.grey.withOpacity(0.35),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                // device icon
                child: Icon(deviceIcon,
                    color: Colors.black,
                    size: 40.0,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.white, offset: Offset(0, 0))]),
              ),
              SizedBox(width: 16.0),
              Text(deviceName, style: TextStyle(color: Colors.black, fontSize: 20.0)),
              SizedBox(width: 8.0),
              Text(deviceStatus, style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)),
              Spacer(),
// on/off button
              Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(Icons.power_settings_new, color: Colors.black, size: 30.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaterLevelTempTile extends StatelessWidget {
  double? temp;
  double? level;

  WaterLevelTempTile({Key? key, this.temp, this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 115,
        // color: Colors.pink,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('수온', style: TextStyle(fontSize: 10)),
                            Flexible(
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    temp == null
                                        ? Text('-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                                        : AnimatedDigitWidget(
                                            animateAutoSize: false,
                                            autoSize: false,
                                            value: temp,
                                            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                            fractionDigits: 1,
                                            curve: Curves.easeOutCirc,
                                            duration: Duration(milliseconds: 1000),
                                            loop: false,
                                          ),
                                    Text('°C', style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalbar(
                      color: Colors.grey.shade100, width: 0.5, height: 100, padding: EdgeInsets.only(left: 0, right: 8)),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                color: Colors.grey.shade100,
                              ),

                              // water level indicator, depends on the water level. animated.
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                height: level! * 0.01 * 100,
                                color: Colors.blue.withOpacity(0.5),
                                curve: Curves.easeInOutCubic,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('수위', style: TextStyle(fontSize: 10)),
                            // depends on the water level: 0~33 is low, 33~66 is medium, 66~100 is high
                            Builder(
                              builder: (context) {
                                if (level! < 33) {
                                  return Text('낮음', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                                } else if (level! < 66) {
                                  return Text('보통', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                                } else {
                                  return Text('높음', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PHGaugeTile extends StatelessWidget {
  double? pH;

  PHGaugeTile({Key? key, this.pH}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 100,
        width: 100,
        child: AnimatedRadialGauge(
          /// The animation duration.
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutCirc,

          /// Gauge value.
          value: pH ?? 7,

          progressBar: const GaugeRoundedProgressBar(color: Colors.transparent),

          /// Optionally, you can configure your gauge, providing additional
          /// styles and transformers.
          axis: GaugeAxis(
            /// Provide the [min] and [max] value for the [value] argument.
            min: 0,
            max: 14,
            segments: [
              GaugeSegment(
                from: 0,
                to: 7,
                color: Colors.red.shade100,
              ),
              GaugeSegment(
                from: 7,
                to: 14,
                color: Colors.blue.shade100,
              ),
            ],

            /// Render the gauge as a 180-degree arc.
            degrees: 100,

            /// Set the background color and axis thickness.
            style: const GaugeAxisStyle(
              thickness: 10,
              background: Colors.transparent,
            ),

            /// Define the pointer that will indicate the progress.
            pointer: RoundedTrianglePointer(
              size: 8,
              borderRadius: 0.9,
              border: GaugePointerBorder(color: Colors.white, width: 0.01),
              position: GaugePointerPosition.surface(
                offset: Offset(0.0, 10), // below the segments
              ),
              backgroundColor: Color(0xFF193663),
            ),
          ),
          builder: (context, child, value) {
            return FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pH != null
                      ? Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          "-",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  Text(
                    'pH',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TVOCTile extends StatelessWidget {
  double? tvoc;

  TVOCTile({Key? key, this.tvoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Row(
              // color left 60% blue and right 40% red
              children: [
                // show the current TVOC level
                tvoc != null
                    ? AnimatedDigitWidget(
                        animateAutoSize: false,
                        autoSize: false,
                        value: tvoc,
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        fractionDigits: 1,
                        curve: Curves.easeOutCirc,
                        duration: Duration(milliseconds: 1000),
                        loop: false,
                      )
                    : Text(
                        "-",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                Text(
                  ' ppb',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(),
              ],
            ),
            SizedBox(height: 3),
            // show colored dot that represents the TVOC level, and the text on the right that says current state e.g. "airing recommended"
            // dot color: blue if < 65, green if 65~220, yellow if 220~660, orange if 660~2200, red if > 2200
            // text: '매우 좋음' if < 65, '좋음' if 65~220, '보통, 환기 권장' if 220~660, '주의, 환기 필요' if 660~2200, '심각' if > 2200
            Row(
              children: [
                Container(
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    color: tvoc != null
                        ? tvoc! < 61
                            ? Colors.blue
                            : tvoc! < 221
                                ? Colors.green
                                : tvoc! < 601
                                    ? Colors.yellow
                                    : tvoc! < 2200
                                        ? Colors.orange
                                        : Colors.red
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  tvoc != null
                      ? tvoc! < 61
                          ? '좋음'
                          : tvoc! < 221
                              ? '양호'
                              : tvoc! < 601
                                  ? '나쁨'
                                  : tvoc! < 2200
                                      ? '주의'
                                      : '심각'
                      : "-",
                  style: const TextStyle(
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DustsTile extends StatelessWidget {
  double? pm; // fine dust
  double? upm; // ultrafine dust

  DustsTile({Key? key, this.pm, this.upm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text('미세먼지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), flex: 1),
            SizedBox(height: 20),
            Expanded(child: Text('초미세먼지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), flex: 1),
          ],
        ),
        FittedBox(
          child: Container(
            width: 100,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // show ug/m3
                          pm != null
                              ? AnimatedDigitWidget(
                                  animateAutoSize: false,
                                  autoSize: false,
                                  value: pm,
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  fractionDigits: 0,
                                  curve: Curves.easeOutCirc,
                                  duration: Duration(milliseconds: 1000),
                                  loop: false,
                                )
                              : Text(
                                  "-",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                          Text(" μg/m³", style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
                          // make a dot color indicator
                          SizedBox(width: 10),
                          Container(
                            height: 4,
                            width: 4,
                            decoration: BoxDecoration(
                              color: pm != null
                                  ? pm! < 31
                                      ? Colors.blue
                                      : pm! < 81
                                          ? Colors.green
                                          : pm! < 151
                                              ? Colors.orange
                                              : Colors.red
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // show ug/m3
                          upm != null
                              ? AnimatedDigitWidget(
                                  animateAutoSize: false,
                                  autoSize: false,
                                  value: upm,
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  fractionDigits: 0,
                                  curve: Curves.easeOutCirc,
                                  duration: Duration(milliseconds: 1000),
                                  loop: false,
                                )
                              : Text(
                                  "-",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                          Text(" μg/m³", style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Container(
                            height: 4,
                            width: 4,
                            decoration: BoxDecoration(
                              color: upm != null
                                  ? upm! < 16
                                      ? Colors.blue
                                      : upm! < 36
                                          ? Colors.green
                                          : upm! < 76
                                              ? Colors.orange
                                              : Colors.red
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class COandCO2GaugeTile extends StatelessWidget {
  double? co;
  double? co2;

  COandCO2GaugeTile({Key? key, this.co, this.co2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          //* NOTE CO
          Container(
            height: 100,
            width: 100,
            child: AnimatedRadialGauge(
              /// The animation duration.
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutCirc,

              /// Gauge value.
              value: co ?? 0,

              progressBar: const GaugeRoundedProgressBar(
                color: Colors.transparent,
              ),

              /// Optionally, you can configure your gauge, providing additional
              /// styles and transformers.
              axis: GaugeAxis(
                /// Provide the [min] and [max] value for the [value] argument.
                min: 0,
                max: 200,
                segments: [
                  GaugeSegment(
                    from: 0,
                    to: 20,
                    color: Colors.blue.shade100,
                  ),
                  GaugeSegment(
                    from: 20,
                    to: 50,
                    color: Colors.green.shade100,
                  ),
                  GaugeSegment(
                    from: 50,
                    to: 200,
                    color: Colors.yellow.shade100,
                  ),
                  // GaugeSegment(
                  //   from: 25,
                  //   to: 800,
                  //   color: Colors.orange.shade100,
                  // ),
                ],

                /// Render the gauge as a 180-degree arc.
                degrees: 200,

                /// Set the background color and axis thickness.
                style: const GaugeAxisStyle(
                  thickness: 5,
                  background: Color(0xFFDFE2EC),
                ),

                /// Define the pointer that will indicate the progress.
                pointer: CirclePointer(
                  radius: 3,
                  border: GaugePointerBorder(color: Colors.white, width: 1),
                  position: GaugePointerPosition.surface(
                    offset: Offset(0.0, 0), // below the segments
                  ),
                  backgroundColor: Color(0xFF193663),
                ),
              ),
              builder: (context, child, value) {
                return FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("CO", style: TextStyle(fontSize: 10)),
                      co != null
                          ? Text(
                              (value >= 200) ? co!.toStringAsFixed(1) : value.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "-",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      Text(
                        'ppm',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 10),
          //* NOTE CO2
          Container(
            height: 100,
            width: 100,
            child: AnimatedRadialGauge(
              /// The animation duration.
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutCirc,

              /// Gauge value.
              value: co2 ?? 0,

              progressBar: const GaugeRoundedProgressBar(
                color: Colors.transparent,
              ),

              /// Optionally, you can configure your gauge, providing additional
              /// styles and transformers.
              axis: GaugeAxis(
                /// Provide the [min] and [max] value for the [value] argument.
                min: 0,
                max: 1000,
                segments: [
                  GaugeSegment(
                    from: 0,
                    to: 450,
                    color: Colors.blue.shade100,
                  ),
                  GaugeSegment(
                    from: 450,
                    to: 700,
                    color: Colors.green.shade100,
                  ),
                  GaugeSegment(
                    from: 700,
                    to: 1000,
                    color: Colors.yellow.shade100,
                  ),
                  // GaugeSegment(
                  //   from: 25,
                  //   to: 2000,
                  //   color: Colors.orange.shade100,
                  // ),
                ],

                /// Render the gauge as a 180-degree arc.
                degrees: 200,

                /// Set the background color and axis thickness.
                style: const GaugeAxisStyle(
                  thickness: 5,
                  background: Color(0xFFDFE2EC),
                ),

                /// Define the pointer that will indicate the progress.
                pointer: CirclePointer(
                  radius: 3,
                  border: GaugePointerBorder(color: Colors.white, width: 1),
                  position: GaugePointerPosition.surface(
                    offset: Offset(0.0, 00), // below the segments
                  ),
                  backgroundColor: Color(0xFF193663),
                ),
              ),
              builder: (context, child, value) {
                return FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("CO2", style: TextStyle(fontSize: 10)),
                      co2 != null
                          ? Text(
                              (value >= 1000) ? this.co2!.toStringAsFixed(1) : value.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "-",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      Text(
                        'ppm',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
