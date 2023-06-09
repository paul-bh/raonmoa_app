import 'dart:async';

import 'package:animated_digit/animated_digit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raonmoa_app/BH_touchFX/bh_touchfx.dart';
import 'package:raonmoa_app/logics/design.dart';
import 'package:raonmoa_app/logics/homeSquareCard.dart';
import 'package:raonmoa_app/ui/charts_pages/co_co2_chart.dart';
import 'package:raonmoa_app/ui/charts_pages/dusts_chart.dart';
import 'package:raonmoa_app/ui/charts_pages/humidity_chart.dart';
import 'package:raonmoa_app/ui/charts_pages/ph_chart.dart';
import 'package:raonmoa_app/ui/charts_pages/temp_chart.dart';
import 'package:raonmoa_app/ui/charts_pages/tvoc_chart.dart';
import 'package:raonmoa_app/ui/charts_pages/water_chart.dart';
import 'package:raonmoa_app/ui/etc/loading.dart';
import 'package:raonmoa_app/ui/example.dart';
import 'package:raonmoa_app/ui/home/tiles.dart';

class MonitorTab extends StatefulWidget {
  MonitorTab({Key? key}) : super(key: key);

  @override
  State<MonitorTab> createState() => _MonitorTabState();
}

class _MonitorTabState extends State<MonitorTab> {
  num? data_temperature;
  num? data_humidity;
  num? data_waterTemp;
  num? data_waterLevel;
  num? data_ph;
  num? data_co;
  num? data_co2;
  num? data_tvoc;
  num? data_pm;
  num? data_upm;
  int? timestamp;

  Query? lastOneDataRef;
  String? myUserId;
  StreamController? _streamController;

  Stream get stream => _streamController!.stream;

  @override
  void initState() {
    // 5 sec delay
    delay();
    super.initState();
  }

  Future<void> delay() async {
    myUserId = FirebaseAuth.instance.currentUser?.uid;

    _streamController = StreamController(sync: true);
    lastOneDataRef = FirebaseDatabase.instance.ref('UsersData/$myUserId/readings').limitToLast(1).orderByKey();
    //await Future.delayed(Duration(seconds: 1));

    lastOneDataRef!.onChildAdded.listen((event) {
      // print('@.@');
      // print(event.snapshot.children.last.value);
      _streamController!.add(event.snapshot.children.last.value);
    });
    lastOneDataRef!.onChildChanged.listen((event) {
      // print('@.@');
      // print(event.snapshot.children.last.value);
      _streamController!.add(event.snapshot.children.last.value);
    });
  }

  @override
  void dispose() {
    _streamController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController!.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Loading(),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('데이터가 존재하지 않습니다.'),
            );
          }
          // print(snapshot.data);
          Map datas = snapshot.data;
          data_temperature = datas['temperature'];
          data_humidity = datas['humidity'];
          data_waterTemp = datas['waterTemp'];
          if (datas['waterLevel'] == "L") data_waterLevel = 10;
          if (datas['waterLevel'] == "M") data_waterLevel = 50;
          if (datas['waterLevel'] == "H") data_waterLevel = 90;

          data_ph = datas['ph'];
          data_co = datas['co'];
          data_co2 = datas['co2'];
          data_tvoc = datas['tvoc'];
          data_pm = datas['pm'];
          data_upm = datas['upm'];
          timestamp = datas['timestamp'];

          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // show the last updated time, in gray color and smaller font
                Container(
                  height: 40.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '마지막 동기화 시간: ${DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000).year}년 ${DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000).month}월 ${DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000).day}일 ${DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000).hour}시 ${DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000).minute}분 ${DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000).second}초',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    // round the corners and put raonmoa colored border
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: $raonmoaColor, width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // thermometer icon, with circle background
                      Flexible(
                        child: BHTouchFXInkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TemperatureChartPage(
                                        initialData: data_temperature!.toDouble(),
                                      )),
                            );
                          },
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          $clickedColor: Colors.transparent,
                          $clickedRadius: 30.0,
                          $clickedShrinkRatio: 0.05,
                          $clickedCurveSizeIn: Curves.easeOutCubic,
                          $clickedCurveSizeOut: Curves.easeOutCubic,
                          $clickedDurationIn: Duration(milliseconds: 50),
                          $clickedDurationOut: Duration(milliseconds: 200),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            // half-transparent rounded background
                            decoration: BoxDecoration(
                              color: $raonmoaColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                              // arrow icon at the right
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Icon(Icons.thermostat_outlined, color: $raonmoaColor),
                                ),
                                Flexible(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("온도", style: topTextStyle_sub),
                                        data_temperature != null
                                            ? FittedBox(
                                                child: AnimatedDigitWidget(
                                                  animateAutoSize: false,
                                                  autoSize: false,
                                                  value: data_temperature!.toDouble(),
                                                  textStyle: topTextStyle,
                                                  fractionDigits: 1,
                                                  curve: Curves.easeOutCirc,
                                                  duration: Duration(milliseconds: 1000),
                                                  loop: false,
                                                  suffix: "°C",
                                                ),
                                              )
                                            : Text("- °C", style: topTextStyle),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, color: $raonmoaColor.withOpacity(0.5), size: 16.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      verticalbar(
                          width: 0.5,
                          height: 50.0,
                          color: Colors.grey.withOpacity(0.0),
                          padding: EdgeInsets.symmetric(horizontal: 8.0)),
                      // humidity icon, with circle background
                      Flexible(
                        child: BHTouchFXInkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HumidityChartPage(
                                        initialData: data_humidity!.toDouble(),
                                      )),
                            );
                          },
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          $clickedColor: Colors.transparent,
                          $clickedRadius: 30.0,
                          $clickedShrinkRatio: 0.05,
                          $clickedCurveSizeIn: Curves.easeOutCubic,
                          $clickedCurveSizeOut: Curves.easeOutCubic,
                          $clickedDurationIn: Duration(milliseconds: 50),
                          $clickedDurationOut: Duration(milliseconds: 200),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            // half-transparent rounded background
                            decoration: BoxDecoration(
                              color: $raonmoaColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Icon(Icons.water_drop_outlined, color: $raonmoaColor),
                                ),
                                Flexible(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("습도", style: topTextStyle_sub),
                                        data_humidity != null
                                            ? FittedBox(
                                                child: AnimatedDigitWidget(
                                                  animateAutoSize: false,
                                                  autoSize: false,
                                                  value: data_humidity!.toDouble(),
                                                  textStyle: topTextStyle,
                                                  fractionDigits: 1,
                                                  curve: Curves.easeOutCirc,
                                                  duration: Duration(milliseconds: 1000),
                                                  loop: false,
                                                  suffix: "%",
                                                ),
                                              )
                                            : Text("? %", style: topTextStyle),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, color: $raonmoaColor.withOpacity(0.5), size: 16.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      // 1번째 줄
                      Row(
                        children: [
                          Expanded(
                              child: homeSquareCard(
                                  title: "수온 / 수위",
                                  child: WaterLevelTempTile(
                                    temp: data_waterTemp != null
                                        ? double.parse(double.tryParse(data_waterTemp.toString())!.toStringAsFixed(1))
                                        : 0.0,
                                    level: data_waterLevel != null
                                        ? double.parse(double.tryParse(data_waterLevel.toString())!.toStringAsFixed(1))
                                        : 0.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WaterChartPage(
                                          initialData: [data_waterTemp!.toDouble(), data_waterLevel!.toDouble()],
                                        ),
                                      ),
                                    );
                                  },
                                  isStacked: false)),
                          Expanded(
                              child: homeSquareCard(
                                  child: DustsTile(
                                    pm: double.tryParse(data_pm.toString()) ?? 0.0,
                                    upm: double.tryParse(data_upm.toString()) ?? 0.0,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DustsChartPage(initialData: [data_pm!.toDouble(), data_upm!.toDouble()]),
                                      ),
                                    );
                                  },
                                  isStacked: true)),
                        ],
                      ),
                      // 2번째 줄
                      Row(
                        children: [
                          Expanded(
                            child: homeSquareCard(
                              child: COandCO2GaugeTile(
                                co: double.tryParse(data_co.toString()) ?? 0.0,
                                co2: double.tryParse(data_co2.toString()) ?? 0.0,
                              ),
                              title: "CO / CO2",
                              ratio: 2,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => COandCO2ChartPage(
                                      initialData: [data_co!.toDouble(), data_co2!.toDouble()],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // 3번째 줄
                      Row(
                        children: [
                          Expanded(
                              child: homeSquareCard(
                            title: widgetData["TVOC"]["title"],
                            child: TVOCTile(
                              tvoc: double.tryParse(data_tvoc.toString()) ?? 0.0,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TVOCChartPage(initialData: data_tvoc!.toDouble()),
                                ),
                              );
                            },
                          )),
                          Expanded(
                            child: homeSquareCard(
                              title: widgetData["pH"]["title"],
                              child: PHGaugeTile(
                                pH: double.parse(double.tryParse(data_ph.toString())!.toStringAsFixed(1)),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PHChartPage(initialData: data_ph!.toDouble()),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ControlTab extends StatefulWidget {
  ControlTab({Key? key}) : super(key: key);

  @override
  State<ControlTab> createState() => _ControlTabState();
}

class _ControlTabState extends State<ControlTab> {
  String? data_light_power;
  String? data_uv_power;
  String? data_pump_power;
  Query? controlDataRef;
  String? myUserId;
  late StreamController _streamController;

  @override
  void initState() {
    delay();
    super.initState();
  }

  Future<void> delay() async {
    myUserId = FirebaseAuth.instance.currentUser?.uid;

    _streamController = StreamController(sync: true);
    controlDataRef = FirebaseDatabase.instance.ref('UsersData/$myUserId/control');
    //await Future.delayed(Duration(seconds: 1));

    controlDataRef!.onValue.listen((event) {
      try {
        _streamController.add(event.snapshot.value as Map<dynamic, dynamic>);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void dispose() {
    // disconnect from firebase
    // _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Loading(),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('데이터가 존재하지 않습니다.'),
            );
          }
          var values = snapshot.data;
          data_light_power = values["led"];
          data_uv_power = values["uv"];
          data_pump_power = values["pump"];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                GridView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: [
                    // show "-" if values are null
                    IotControllerTile(
                      deviceName: "조명 LED",
                      deviceStatus: data_light_power == null ? '-' : data_light_power!,
                      deviceIcon: Icons.lightbulb_outline,
                      onTap: () async {
                        if (data_light_power!.toUpperCase() == "ON") {
                          // ensure the data has updated in firebase!
                          await FirebaseDatabase.instance.ref('UsersData/$myUserId/control').update({"led": "OFF"});
                        } else {
                          await FirebaseDatabase.instance.ref('UsersData/$myUserId/control').update({"led": "ON"});
                        }
                      },
                    ),
                    IotControllerTile(
                      deviceName: "UV LED",
                      deviceStatus: data_uv_power == null ? '-' : data_uv_power!,
                      deviceIcon: Icons.wb_iridescent_outlined,
                      onTap: () {
                        if (data_uv_power!.toUpperCase() == "ON") {
                          FirebaseDatabase.instance.ref('UsersData/$myUserId/control').update({"uv": "OFF"});
                        } else {
                          FirebaseDatabase.instance.ref('UsersData/$myUserId/control').update({"uv": "ON"});
                        }
                      },
                    ),
                    IotControllerTile(
                      deviceName: "펌프",
                      deviceStatus: data_pump_power == null ? '-' : data_pump_power!,
                      deviceIcon: Icons.water_damage_outlined,
                      onTap: () {
                        if (data_pump_power!.toUpperCase() == "ON") {
                          FirebaseDatabase.instance.ref('UsersData/$myUserId/control').update({"pump": "OFF"});
                        } else {
                          FirebaseDatabase.instance.ref('UsersData/$myUserId/control').update({"pump": "ON"});
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
