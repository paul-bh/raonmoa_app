import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class SVSHorizontalBarChart extends StatefulWidget {
  const SVSHorizontalBarChart({Key? key, required this.data, required this.useTestMode}) : super(key: key);

  final Map<String, double> data;
  final bool useTestMode;

  @override
  State<SVSHorizontalBarChart> createState() => _SVSHorizontalBarChartState();
}

class _SVSHorizontalBarChartState extends State<SVSHorizontalBarChart> {
  double chartLength = 200;
  double _chartLengthNow = 0;
  double _chartBackdropLengthNow = 0;
  double _chartBackdropAutoCalculatedLength = 0;
  double logoHeight = 25;
  double logoWidthFactor = 3;
  double chartWidth = 8;
  double labelWidth = 22;

  double _opacityNow = 0;

  bool __DBGshowBoxAreas = false;
  bool useAutoWidth = true;

  List<Widget> _rowList = [];

  @override
  void initState() {
    super.initState();
    updateData();
    animate();
  }

  void animate() async {
    //* ANCHOR 투명도 애니메이션 재시작
    _opacityNow = 1;

    //* ANCHOR 차트 배경색 딜레이 및 애니메이션
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      setState(() {
        _chartBackdropLengthNow = chartLength;
        updateData();
      });
      // additional delay for chart length
    }).then((_) {
      //* ANCHOR 차트 애니메이션
      setState(() {
        _chartLengthNow = chartLength;
        updateData();
      });
    });
  }

  //get maximum value from widget.data
  void updateData() {
    _rowList.clear();
    double _maxValue = 0;
    widget.data.forEach((key, value) {
      if (value > _maxValue) {
        _maxValue = value;
      }
    });

    Map<String, double> rawData = widget.data;
    //convert widget.data into sorted list
    List<MapEntry<String, double>> _sortedData = rawData.entries.toList()..sort((b, a) => a.value.compareTo(b.value));
    widget.data
      ..clear()
      ..addEntries(_sortedData); // 정렬한 값을 대체

    setState(() {
      rawData.forEach((key, value) {
        _rowList.add(
          Column(
            children: [
              // NOTE 각 줄 위에 추가될 간격
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  // NOTE 쇼핑몰 로고
                  Container(
                    color: (__DBGshowBoxAreas) ? Colors.amber : null,
                    margin: EdgeInsets.only(left: 20, right: 15),
                    width: logoHeight * logoWidthFactor,
                    height: logoHeight,
                    // get image using getBanner
                    child: Container(),
                  ),

                  // NOTE 실제 그래프
                  Container(
                    color: (__DBGshowBoxAreas) ? Colors.cyan : null,
                    width: _chartLengthNow,
                    child: Container(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 1500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: value / _maxValue * _chartLengthNow,
                                child: Container(
                                  height: chartWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1600),
                                    gradient: // linear gradient indigo left 70%, red right 30%
                                        LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.indigo,
                                        Color.lerp(Colors.indigo, Colors.red, pow(value / _maxValue, 2).toDouble())!,
                                      ],
                                      stops: [pow(1 - value / _maxValue, 0.5).toDouble(), 1],
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),

                          // NOTE backdrop
                          AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeOutCirc,
                            width: _chartBackdropLengthNow,
                            height: chartWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1600),
                              color: Colors.black12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // NOTE value label
                  Container(
                    color: (__DBGshowBoxAreas) ? Colors.pink : null,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    height: logoHeight,
                    width: labelWidth,
                    child: AnimatedOpacity(
                      opacity: _opacityNow,
                      curve: Curves.easeOutCirc,
                      duration: Duration(milliseconds: 2000),
                      child: Text(
                        value.round().toString(),
                        style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _chartBackdropAutoCalculatedLength = constraints.maxWidth - logoHeight * logoWidthFactor - labelWidth - 57;
      (useAutoWidth) ? chartLength = _chartBackdropAutoCalculatedLength : null;
      return Column(
        children: (!widget.useTestMode)
            ? _rowList
            : [
                Column(
                  // entire chart widget
                  children: _rowList,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('요소 영역 보기'),
                        Checkbox(
                          value: __DBGshowBoxAreas,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            setState(() {
                              __DBGshowBoxAreas = !__DBGshowBoxAreas;
                              updateData();
                            });
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      child: Text('refresh'),
                      onPressed: () {
                        _chartLengthNow = 0;
                        _chartBackdropLengthNow = 0;
                        animate();
                        updateData();
                      },
                    ),
                    //slider that change logoHeight, logoWidthFactor, chartWidth, labelWidth
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('차트 길이: ${chartLength.toInt()}'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    Text('자동 계산된 길이 사용'),
                    Checkbox(
                      onChanged: (value) {
                        useAutoWidth = !useAutoWidth;
                        HapticFeedback.lightImpact();
                        updateData();
                        animate();
                      },
                      value: useAutoWidth,
                    ),
                  ],
                ),
                Slider(
                  min: 0,
                  max: 1000,
                  divisions: (400 / 1).round().toInt(),
                  value: chartLength,
                  onChanged: (useAutoWidth)
                      ? null
                      : (value) {
                          setState(() {
                            chartLength = value;
                          });
                          animate();
                          updateData();
                        },
                ),
                Text('차트 두께: ${chartWidth.toInt()}'),
                Slider(
                  min: 0,
                  max: 50,
                  divisions: (50 / 1).round().toInt(),
                  value: chartWidth,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      chartWidth = value;
                    });
                    updateData();
                  },
                ),
                Text('로고 세로 길이: ${logoHeight.toInt()}'),
                Slider(
                  min: 0,
                  max: 30,
                  divisions: (30 / 0.1).round().toInt(),
                  value: logoHeight,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      logoHeight = value;
                    });
                    updateData();
                  },
                ),
                Text('로고 가로 길이 배수: ${logoWidthFactor.toInt()}'),
                Slider(
                  min: 0,
                  max: 5,
                  divisions: (30 / 1).round().toInt(),
                  value: logoWidthFactor,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      logoWidthFactor = value;
                    });
                    updateData();
                  },
                ),
                Text('라벨 길이: ${labelWidth.toInt()}'),
                Slider(
                  min: 0,
                  max: 70,
                  divisions: (70 / 1).round().toInt(),
                  value: labelWidth,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      labelWidth = value;
                    });
                    updateData();
                  },
                ),
              ],
      );
    });
  }
}
