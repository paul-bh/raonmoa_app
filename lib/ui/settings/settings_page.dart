import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raonmoa_app/logics/design.dart';
import 'package:raonmoa_app/logics/settings.dart';
import 'package:raonmoa_app/ui/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('설정', style: TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.transparent,
        toolbarHeight: 50,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            height: 0,
            decoration: BoxDecoration(
              color: $raonmoaColor,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        // make a sample settings list with following items: 'Enable high performance mode'
        children: [
          ListTile(
            title: Text('정밀 모드'),
            trailing: CupertinoSwitch(
              // use getter
              value: Settings.useHighCapacityMode,
              onChanged: (value) {
                setState(() {
                  Settings.useHighCapacityMode = value;
                  // save to shared preferences
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool('useHighCapacityMode', value);
                  });
                });
              },
            ),
            contentPadding: EdgeInsets.only(left: 16.0, right: 16.0),
            //minVerticalPadding: 25,
          ),
          // write explanation of the above settings, with smaller font size
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              '그래프에서 모든 데이터를 표시합니다. 저사양 기기에서 성능 문제가 발생할 수 있습니다. \n비활성화시 15분 단위로 데이터를 표시합니다.',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          Divider(),
          // '계정'
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
            child: Text('계정', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
          ),

          // log out button
          ListTile(
            // show currently logged in user's email
            title: Text('${FirebaseAuth.instance.currentUser!.email}'),
            trailing: TextButton(
                child: Text('로그아웃', style: TextStyle(color: Colors.red)),
                // no splash
                style: TextButton.styleFrom(
                  // disable splash effect
                  splashFactory: NoSplash.splashFactory,
                  foregroundColor: Colors.grey.shade100,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('로그아웃 하시겠습니까?'),
                        // border radius
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        alignment: Alignment.center,
                        actionsPadding: EdgeInsets.only(right: 20, bottom: 10),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              // disable splash effect
                              splashFactory: NoSplash.splashFactory,
                              foregroundColor: Colors.grey.shade100,
                            ),
                            child: Text('취소', style: TextStyle(color: $raonmoaColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              // disable splash effect
                              splashFactory: NoSplash.splashFactory,
                              foregroundColor: Colors.grey.shade100,
                            ),
                            child: Text('로그아웃', style: TextStyle(color: $raonmoaColor)),
                            onPressed: () async {
                              // log out. while logging out, show fullscreen progress indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    child: Container(
                                      width: 150,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CupertinoActivityIndicator(),
                                          SizedBox(height: 10),
                                          Text('로그아웃 중...', style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              // wait 1 seconds

                              await FirebaseAuth.instance.signOut();
                              await Future.delayed(Duration(seconds: 1));
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('autoLogin', false);

                              // go to login page
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
            contentPadding: EdgeInsets.only(left: 16.0, right: 16.0),
            minVerticalPadding: 25,
          ),
        ],
      ),
    );
  }
}
