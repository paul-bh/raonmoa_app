import 'package:flutter/material.dart';

// //! ph chart example unused
// AnimatedChart(
//       state: ChartState(
//           data: data,
//           itemOptions: BubbleItemOptions(
//             bubbleItemBuilder: (p0) {
//               // transparent except for the last item
//               return BubbleItem(
//                 color: p0 == data.items[0].length - 1 ? Colors.red : Colors.transparent,
//               );
//             },
//           ),
//           foregroundDecorations: [
//             HorizontalAxisDecoration(
//               showValues: true,
//               showLines: false,
//               showLineForValue: (value) {
//                 return value % 7 == 0;
//               },
//               showTopValue: true,
//               lineColor: Colors.black12,
//               axisStep: 7,
              
//               legendFontStyle: TextStyle(color: Colors.black87, fontSize: 12),
//               axisValue: (value) => 'pH ' + value.toString(),
//             ),
//             SparkLineDecoration(
//               fill: false,
//               lineColor: Colors.red,
//               lineWidth: 3,
//               smoothPoints: true,
//             ),
//           ],
//           backgroundDecorations: [
//             WidgetDecoration(
//               widgetDecorationBuilder: (context, chartState, itemWidth, verticalMultiplier) {
//                 // gradient background, from blue to red vertically
//                 return Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.blue.shade100,
//                         Colors.red.shade100,
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//           ]),
//       duration: Duration(seconds: 1),
//     )