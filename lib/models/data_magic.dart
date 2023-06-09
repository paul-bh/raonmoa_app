// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// Map<dynamic, dynamic> ALLDATA = {};

// class DataMagicHandler {
//   static Future<void> loadFirstData() async {
//     ALLDATA.clear();
//     String? myUserId = FirebaseAuth.instance.currentUser?.uid;
//     // load first data
//     DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
//     var firstDataSnapshot = await databaseRef.child("UsersData/$myUserId/readings").limitToLast(100).get();
//     var receivedData = firstDataSnapshot.value as Map;
//     // print(receivedData); 
//     Map firstData = {};
//     receivedData.forEach((key, value) {
//       firstData[key] = value;
//     });

//     // print(firstData);
//     // update data and sort
//     ALLDATA.addAll(firstData);
//     ALLDATA = Map.fromEntries(ALLDATA.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key)));
//     // ALLDATA.forEach((key, value) {
//     //   print("$key: ${value['ph']}");
//     //   print("$key: ${value['ph'].runtimeType}");
//     // });
//   }

//   static Future<bool> loadMoreData() async {
//     var myUserId = FirebaseAuth.instance.currentUser?.uid;
//     // load more data
//     var databaseRef = FirebaseDatabase.instance.ref("UsersData/$myUserId/readings");
//     var lastKey = ALLDATA.keys.last;
//     print(lastKey);
//     try {
//       var moreDataSnapshot = await databaseRef.orderByKey().endBefore(lastKey).limitToLast(100).get();
//       Map<dynamic, dynamic> moreData = moreDataSnapshot.value as Map<dynamic, dynamic>;
//       //print(moreData);
//       // update data and sort
//       ALLDATA.addAll(moreData);
//       ALLDATA = Map.fromEntries(ALLDATA.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key)));

//       //print(ALLDATA.keys.length);
//       return true;
//     } catch (e) {
//       // this is when there is no more data to load
//       return false;
//     }
//   }

//   static Future<Map<dynamic, dynamic>> loadToCertainDate(DateTime date) async {
//     ALLDATA.clear();
//     // if ALLDATA is empty, load first data
//     if (ALLDATA.isEmpty) {
//       await loadFirstData();
//     }
//     // keep loading more data and add to ALLDATA until we have enough data. check if ALLDATA's first key is before the date
//     while (!DateTime.parse(ALLDATA.keys.first).isBefore(date)) {
//       var isThereMoreData = await loadMoreData();

//       if (!isThereMoreData) {
//         break;
//       }
//     }
//     // return
//     return ALLDATA as Map;
//   }
// }

// var DMH = DataMagicHandler();
