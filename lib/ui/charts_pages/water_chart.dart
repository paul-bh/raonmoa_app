import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raonmoa_app/BH_touchFX/bh_touchfx.dart';
import 'package:raonmoa_app/logics/design.dart';
import 'package:raonmoa_app/logics/settings.dart';
import 'package:raonmoa_app/models/chart_extralines_standards.dart';
import 'package:raonmoa_app/models/data_magic.dart';
import 'package:raonmoa_app/ui/etc/loading.dart';

class WaterChartPage extends StatefulWidget {
  late List<double> initialData;

  WaterChartPage({Key? key, required this.initialData}) : super(key: key);

  @override
  State<WaterChartPage> createState() => _WaterChartPageState();
}

class _WaterChartPageState extends State<WaterChartPage> {
  List<FlSpot> example_spots = <FlSpot>[
    FlSpot(0, 0),
  ];
  String? myUserId;

  List<FlSpot> spots = <FlSpot>[];
  double _touchedX = 0;
  double _touchedY = 0;
  bool _touched = false;
  Color mainColor = Colors.redAccent;
  Color _touchedColor = Colors.transparent;
  double _lowestY = 0;
  List<double> _x_of_lowestY = [0];
  double _highestY = 0;
  List<double> _x_of_highestY = [0];
  double _averageY = 0;
  DateTime _pickedDate = DateTime.now();
  bool _noData = true;
  double? _todayLatestY;
  double? _selectedMode = 0;

  DatabaseReference? DateDataRef;
  StreamController? _streamController;

  @override
  void initState() {
    spots = example_spots;
    delay();
    super.initState();
  }

  Future<void> delay() async {
    _touchedX = _pickedDate.millisecondsSinceEpoch / 1000;
    myUserId = FirebaseAuth.instance.currentUser?.uid;
    _streamController = StreamController();
    // picked data in YYYYMMDD format
    DateDataRef = FirebaseDatabase // get the last one data
        .instance
        .ref()
        .child('UsersData')
        .child(myUserId!)
        .child('readings')
        .child(DateFormat('yyyyMMdd').format(_pickedDate));
    //await Future.delayed(Duration(seconds: 1));

    DateDataRef!.onValue.listen((event) {
      _streamController!.add(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget changeToTodayButton = Container(
      height: 50,
      padding: EdgeInsets.only(right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BHTouchFXInkWell(
            onTap: _pickedDate.day == DateTime.now().day
                ? null
                : () {
                    setState(() {
                      _pickedDate = DateTime.now();
                      delay();
                    });
                  },
            $clickedColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text('오늘', style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text('수온/수위'),
        // a button to return to today
        actions: [
          AnimatedOpacity(
            opacity: _pickedDate.day == DateTime.now().day ? 0 : 1,
            duration: Duration(milliseconds: 100),
            child: changeToTodayButton,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 4),
            // a container that shows the current touched spot
            // show as: PM 2:53 \n 7.76
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _touched ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        ' ${DateFormat('a H:mm').format(DateTime.fromMillisecondsSinceEpoch(_touchedX.toInt() * 1000))}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      _selectedMode == 0
                          ? Text(
                              '${_touchedY.toStringAsFixed(1)} °C',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          :
                          // evaluate _touchedY to string: 25 is 낮음, 50 is 보통, 75 is 높음, 100 is 매우높음
                          Text(
                              _touchedY == 25
                                  ? '낮음'
                                  : _touchedY == 50
                                      ? '보통'
                                      : _touchedY == 75
                                          ? '높음'
                                          : '-',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: _touched ? 0 : 1,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                    child:
                        // show current value as the form in the sibling text
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // make a tab selector that changes the selected mode.
                        Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BHTouchEffectWrapper(
                                $clickedColor: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedMode = 0;
                                      delay();
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _selectedMode == 0 ? Colors.black : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text('수온',
                                        style:
                                            TextStyle(color: _selectedMode == 0 ? Colors.white : Colors.black, fontSize: 18)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              BHTouchEffectWrapper(
                                $clickedColor: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedMode = 1;
                                      delay();
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _selectedMode == 1 ? Colors.black : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text('수위',
                                        style:
                                            TextStyle(color: _selectedMode == 1 ? Colors.white : Colors.black, fontSize: 18)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // show currently selected date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // left arrow, current date, right arrow
                            Container(
                              height: 50,
                              width: 50,
                              child: BHTouchFXInkWell(
                                onTap: () {
                                  setState(() {
                                    _pickedDate = _pickedDate.subtract(Duration(days: 1));
                                    // rebuild stream
                                    delay();
                                  });
                                },
                                $clickedColor: Colors.black.withOpacity(0.1),
                                highlightColor: Colors.transparent,
                                child: Icon(Icons.arrow_back, color: Colors.black, size: 18),
                              ),
                            ),
                            Container(
                              height: 50,
                              child: BHTouchFXInkWell(
                                $clickedColor: Colors.black.withOpacity(0.1),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  // show date picker
                                  _pickedDate = await _selectDate(context) ?? _pickedDate;
                                  delay();
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today, color: Colors.black, size: 18),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        DateFormat('yyyy년 M월 d일').format(_pickedDate),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // don't show right arrow if the last spot is today
                            DateFormat('yyyyMMdd').format(_pickedDate) != DateFormat('yyyyMMdd').format(DateTime.now())
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    child: BHTouchFXInkWell(
                                      onTap: () {
                                        setState(() {
                                          _pickedDate = _pickedDate.add(Duration(days: 1));
                                          delay();
                                        });
                                      },
                                      $clickedColor: Colors.black.withOpacity(0.1),
                                      highlightColor: Colors.transparent,
                                      child: Icon(Icons.arrow_forward, color: Colors.black, size: 18),
                                    ),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                  ),
                          ],
                        ),
                        // only show 현재 if the last spot is today
                        DateFormat('yyyyMMdd').format(_pickedDate) == DateFormat('yyyyMMdd').format(DateTime.now()) && !_noData
                            ? Container(
                                child: Column(
                                  children: [
                                    Text(
                                      '현재',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    _selectedMode == 0
                                        ? Text(
                                            '${widget.initialData[0].toStringAsFixed(1)} °C',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            // evaluate L as 낮음, M as 보통, H as 높음
                                            '${widget.initialData[1] <= 25 ? '낮음' : widget.initialData[1] <= 50 ? '보통' : widget.initialData[1] <= 75 ? '높음' : '-'}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: _streamController!.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  _noData = true;
                  return Center(
                    child: Text('데이터가 존재하지 않습니다.'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Builder(builder: (context) {
                          return Loading();
                        }),
                      ],
                    ),
                  );
                }
                _noData = false;
                // convert key and ph as flspots data
                spots.clear();
                snapshot.data?.forEach((key, value) {
                  if (_selectedMode == 0) {
                    spots.add(FlSpot(double.parse(key.toString()), double.parse(value['waterTemp'].toString())));
                  } else {
                    double waterLevel = 0;
                    if (value['waterLevel'] == 'L' || value['waterLevel'] == 'l') {
                      waterLevel = 25;
                    } else if (value['waterLevel'] == 'M' || value['waterLevel'] == 'm') {
                      waterLevel = 50;
                    } else if (value['waterLevel'] == 'H' || value['waterLevel'] == 'h') {
                      waterLevel = 75;
                    }
                    spots.add(FlSpot(double.parse(key.toString()), waterLevel));
                  }
                });
                // sort spots
                spots.sort((a, b) => a.x.compareTo(b.x));

                // but if Settings.useHighCapacityMode is true, remove spots that are too close to each other based on the given 'Settings.graphViewIntervalSeconds'.
                if (!Settings.useHighCapacityMode) {
                  FlSpot last_sampled_spot = spots.first;
                  // remove spots that are too close to each other
                  spots.removeWhere((element) {
                    if (element.x - last_sampled_spot.x > Settings.graphViewIntervalSeconds) {
                      last_sampled_spot = element;
                      return false;
                    }
                    return true;
                  });
                }
                //print(spots.length);

                mainColor = _selectedMode == 0 ? Colors.red : Colors.blue;

                // process data for the chart
                // based on the spots data, get the lowest and highest y value with corresponding x value. _lowestY and _highestY, _x_of_lowestY, _x_of_highestY
                _lowestY = spots[0].y;
                _highestY = spots[0].y;
                _x_of_lowestY.add(spots[0].x);
                _x_of_highestY.add(spots[0].x);
                spots.forEach((element) {
                  if (element.y < _lowestY) {
                    _lowestY = element.y;
                    _x_of_lowestY = [element.x];
                  }
                  if (element.y > _highestY) {
                    _highestY = element.y;
                    _x_of_highestY = [element.x];
                  }
                });
                // get average y value
                _averageY = 0;
                spots.forEach((element) {
                  _averageY += element.y;
                });
                _averageY /= spots.length;

                // get the latest y value if the last spot is today
                if (DateFormat('yyyyMMdd').format(DateTime.fromMillisecondsSinceEpoch(spots.last.x.toInt() * 1000)) ==
                    DateFormat('yyyyMMdd').format(DateTime.now())) {
                  _todayLatestY = spots.last.y;
                }

                return Column(
                  children: [
                    Container(
                      height: 300,
                      //color: Colors.yellow,
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                      width: MediaQuery.of(context).size.width,
                      child: LineChart(
                        LineChartData(
                          backgroundColor: Colors.transparent,
                          // min x is _pickedDate but at 00:00:00
                          minX: DateTime(_pickedDate.year, _pickedDate.month, _pickedDate.day).millisecondsSinceEpoch / 1000,
                          // min x + 1 day
                          maxX:
                              DateTime(_pickedDate.year, _pickedDate.month, _pickedDate.day + 1).millisecondsSinceEpoch / 1000,
                          minY: 0,
                          maxY: _selectedMode == 0
                              ? _highestY > 30
                                  ? _highestY * 1.1
                                  : 31
                              : 100,
                          borderData: FlBorderData(
                              show: true, border: Border.all(color: Colors.red, width: 1, style: BorderStyle.none)),
                          extraLinesData: ExtraLinesData(
                            extraLinesOnTop: true,
                            horizontalLines: null,
                            verticalLines: [
                              if (_touched == true)
                                VerticalLine(
                                  x: _touchedX,
                                  color: _touchedColor,
                                  strokeWidth: 3,
                                  label: VerticalLineLabel(
                                    labelResolver: (p0) {
                                      return ' ${DateFormat('H:mm').format(DateTime.fromMillisecondsSinceEpoch(_touchedX.toInt() * 1000))}';
                                    },
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    alignment: Alignment.topRight,
                                    show: true,
                                    style: TextStyle(
                                      color: _touchedColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: true,
                            horizontalInterval: _selectedMode == 0 ? 5 : 25,
                            // vertical invterval is 3 hours
                            verticalInterval: 3 * 60 * 60,
                            getDrawingHorizontalLine: (value) {
                              if (_selectedMode == 0) {
                                if (value % 10 == 0) {
                                  return FlLine(
                                    color: Colors.black.withOpacity(0.5),
                                    strokeWidth: 0.5,
                                  );
                                } else
                                  return FlLine(
                                    color: Colors.black.withOpacity(0.2),
                                    strokeWidth: 0.5,
                                    dashArray: [3, 5],
                                  );
                              } else {
                                if (value % 25 == 0) {
                                  return FlLine(
                                    color: Colors.black.withOpacity(0.5),
                                    strokeWidth: 0.5,
                                  );
                                } else
                                  return FlLine(
                                    color: Colors.black.withOpacity(0.2),
                                    strokeWidth: 0.5,
                                    dashArray: [3, 5],
                                  );
                              }
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.black.withOpacity(0.2),
                                strokeWidth: 0.5,
                              );
                            },
                          ),
                          lineBarsData: <LineChartBarData>[
                            LineChartBarData(
                              spots: spots,
                              barWidth: spots.length > 480 ? 1.5 : 2.5,
                              shadow: Shadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 2),
                              ),
                              showingIndicators: _touched ? [0] : [],
                              isCurved: _selectedMode == 1
                                  ? false
                                  : Settings.useHighCapacityMode
                                      ? false
                                      : true,
                              curveSmoothness: 0.4,
                              preventCurveOverShooting: false,
                              // make a horizontal gradient going from white to red horizontally
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  mainColor.withOpacity(0),
                                  mainColor,
                                ],
                              ),
                              aboveBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.blue.withOpacity(0),
                                    Colors.blue.withOpacity(0),
                                  ],
                                ),
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    mainColor.withOpacity(0.2),
                                    mainColor.withOpacity(0.0),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                getDotPainter: (p0, p1, p2, p3) {
                                  //if the spot is the last one AND if _pickedData is today, draw a bigger circle
                                  if (p0.x == spots.last.x &&
                                      DateTime.fromMillisecondsSinceEpoch(p0.x.toInt() * 1000).day == DateTime.now().day) {
                                    return FlDotCirclePainter(
                                      radius: 5,
                                      color: mainColor,
                                      strokeWidth: 0,
                                      strokeColor: Colors.white,
                                    );
                                  }
                                  // show the highest and lowest value with a bigger circle
                                  if ((p0.y == _lowestY || p0.y == _highestY) && _selectedMode == 0) {
                                    return FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.black,
                                      strokeWidth: 1,
                                      strokeColor: Colors.transparent,
                                    );
                                  }

                                  // ordinary dots
                                  return FlDotCirclePainter(
                                    radius: 0,
                                    color: Colors.redAccent,
                                    strokeWidth: 0.0,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              isStepLineChart: _selectedMode == 1 ? true : false,
                              isStrokeCapRound: true,
                            ),
                          ],

                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                // intervals are 6 hours
                                interval: 10800,
                                getTitlesWidget: (value, meta) {
                                  // convert unix timestamp to this form: PM 3. only show every 6 hours. timezone is gmt+9
                                  if (value.toInt() % 21600 != 0) {
                                    return Text(
                                      // the form should be like: PM 3
                                      DateFormat('a H').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt() * 1000,
                                        ).toUtc().add(
                                              Duration(hours: 9),
                                            ),
                                      ),
                                      style: TextStyle(color: Colors.grey, fontSize: 10),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: _selectedMode == 0 ? 50 : 40,
                                getTitlesWidget: (value, meta) {
                                  if (_selectedMode == 0) {
                                    if (value.toInt() % 10 == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${value.toInt().toString()}',
                                                  style: TextStyle(color: Colors.grey, fontSize: 10),
                                                ),
                                                Text(
                                                  '°C',
                                                  style: TextStyle(color: Colors.grey, fontSize: 7),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    // 25 is 낮음, 75 is 높음, 50 is 보통
                                    if (value.toInt() == 25) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '낮음',
                                                  style: TextStyle(color: Colors.grey, fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (value.toInt() == 50) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '보통',
                                                  style: TextStyle(color: Colors.grey, fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (value.toInt() == 75) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '높음',
                                                  style: TextStyle(color: Colors.grey, fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }
                                },
                                interval: _selectedMode == 0 ? 10 : 25,
                              ),
                            ),
                          ),
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            enabled: true,
                            touchSpotThreshold: 999999,
                            touchCallback: (p0, p1) {
                              if (p0 is FlPanDownEvent ||
                                  p0 is FlLongPressStart ||
                                  p0 is FlLongPressMoveUpdate ||
                                  p0 is FlPanStartEvent ||
                                  p0 is FlPanUpdateEvent ||
                                  p0 is FlTouchEvent) {
                                _touched = true;
                                setState(() {});
                              }

                              if (p0 is FlTapUpEvent ||
                                  p0 is FlPanEndEvent ||
                                  p0 is FlLongPressEnd ||
                                  p0 is FlPointerHoverEvent ||
                                  p0 is FlPointerExitEvent) {
                                _touched = false;
                                _touchedColor = Colors.transparent;
                                setState(() {});
                              }
                            },
                            getTouchedSpotIndicator: (barData, spotIndexes) {
                              // both vertical and horizontal indicator
                              return spotIndexes.map((index) {
                                _touchedX = barData.spots[index].x;
                                _touchedY = barData.spots[index].y;
                                _touchedColor = Colors.black;
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.transparent,
                                    strokeWidth: 2,
                                  ),
                                  FlDotData(
                                    getDotPainter: (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 4,
                                        color: Colors.black,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      );
                                    },
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.white.withOpacity(0.4),
                              showOnTopOfTheChartBoxArea: false,
                              tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                              tooltipPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                // convert unix timestamp to this form: 13:34 \n
                                return touchedBarSpots.map((barSpot) {
                                  return LineTooltipItem(
                                    // show 낮음, 보통, 높음 when the value is 25, 50, 75
                                    '${_selectedMode == 0 ? DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(barSpot.x.toInt() * 1000).toUtc().add(Duration(hours: 9))) : barSpot.y.toInt() == 25 ? '낮음' : barSpot.y.toInt() == 50 ? '보통' : '높음'}',

                                    TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                            ),
                          ),
                        ),
                        // chart animation
                        swapAnimationDuration: Duration(milliseconds: 0), // Optional
                        swapAnimationCurve: Curves.linear, // Optional
                      ),
                    ),

                    Divider(
                      color: Colors.black.withOpacity(0.1),
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    //* show today's highest and lowest values
                    _selectedMode == 0
                        ? Container(
                            width: double.infinity,
                            child: FittedBox(
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Card(
                                  // decorate with rounded corners, borders and background color and shadow
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors.black.withOpacity(0.0),
                                      width: 1,
                                    ),
                                  ),
                                  color: Colors.black.withOpacity(0.05),
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '정보',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        // show time range, in H:MM format.
                                        Text(
                                          '${DateFormat('H시 mm분').format(DateTime.fromMillisecondsSinceEpoch(spots[0].x.toInt() * 1000).toUtc().toLocal())} ~ ${DateFormat('H시 mm분').format(DateTime.fromMillisecondsSinceEpoch(spots[spots.length - 1].x.toInt() * 1000).toUtc().toLocal())}',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.5),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '최고 ',
                                                  style: TextStyle(
                                                    color: Color.lerp(Colors.black, Colors.red, 0.8),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '${_highestY.toStringAsFixed(1)} °C',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  // show as: (H:MM, H:MM, H:MM because there are multiple key with the same values)
                                                  ' ${() {
                                                    String result = '';
                                                    int count = 0;
                                                    for (int i = 0; i < spots.length; i++) {
                                                      if (spots[i].y == _highestY && count++ < 3) {
                                                        result +=
                                                            '${DateFormat('H:mm').format(DateTime.fromMillisecondsSinceEpoch(spots[i].x.toInt() * 1000).toUtc().toLocal())}, ';
                                                      }
                                                    }
                                                    return '(${result.substring(0, result.length - 2)}${count > 3 ? '...' : ''})';
                                                  }()}',

                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '최저 ',
                                                  style: TextStyle(
                                                    color: Color.lerp(Colors.black, Colors.blue, 0.8),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '${_lowestY.toStringAsFixed(1)} °C',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  // show as: (H:MM, H:MM, H:MM because there are multiple key with the same values)
                                                  ' ${() {
                                                    String result = '';
                                                    int count = 0;
                                                    for (int i = 0; i < spots.length; i++) {
                                                      if (spots[i].y == _lowestY && count++ < 3) {
                                                        result +=
                                                            '${DateFormat('H:mm').format(DateTime.fromMillisecondsSinceEpoch(spots[i].x.toInt() * 1000).toUtc().toLocal())}, ';
                                                      }
                                                    }
                                                    return '(${result.substring(0, result.length - 2)}${count > 3 ? '...' : ''})';
                                                  }()}',

                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // average value
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '평균 ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '${_averageY.toStringAsFixed(1)} °C',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

// make a function that shows a  date picker
  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime selectedDate = _pickedDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
      confirmText: '선택',
      cancelText: '취소',
      helpText: '날짜를 선택하세요. ',

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              onPrimary: Colors.black,
              primary: $raonmoaColor.withOpacity(0.5),
              inversePrimary: Colors.teal,
              surface: Colors.black,
              onSurface: Colors.black,
              // change current date color in calendar
              primaryContainer: $raonmoaColor,
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            // change button color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: $raonmoaColor,
              ),
            ),
            // change all text size in calendar
            textTheme: TextTheme(
              caption: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 달력 날짜
              button: TextStyle(fontSize: 17), // 버튼 글자
              headline4: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // 선택된 날짜
              overline: TextStyle(fontSize: 15), // 상단 안내문구
            ),
          ),
          child: child!,
        );
      },
      errorFormatText: '잘못된 형식입니다',
      errorInvalidText: '유효하지 않은 날짜입니다',
      fieldLabelText: '날짜',
      fieldHintText: 'YYYY/MM/DD',
      locale: const Locale('ko', 'KR'),
      initialEntryMode: DatePickerEntryMode.calendar,
      selectableDayPredicate: (day) {
        // Disable days after today
        if (day.isAfter(DateTime.now())) return false;

        return true;
      },
    );
    // return null if the user cancels the date picker
    if (picked != null && picked != selectedDate) return picked;
    return null;
  }
}
