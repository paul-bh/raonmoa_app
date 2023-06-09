import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raonmoa_app/BH_touchFX/bh_touchfx.dart';
import 'package:raonmoa_app/logics/design.dart';
import 'package:raonmoa_app/logics/homeSquareCard.dart';
import 'package:raonmoa_app/ui/home/tabs.dart';
import 'package:raonmoa_app/ui/home/tiles.dart';
import 'package:raonmoa_app/ui/settings/settings_page.dart';

class RaonmoaHome extends StatefulWidget {
  RaonmoaHome({Key? key}) : super(key: key);

  @override
  State<RaonmoaHome> createState() => _RaonmoaHomeState();
}

class _RaonmoaHomeState extends State<RaonmoaHome> with TickerProviderStateMixin {
  final Color _backgroundColor = Color.lerp($raonmoaColor, Colors.white, 0.95) ?? Colors.red;
  List<Widget> _tabs = [];
  late TabController _tabController = TabController(length: 2, vsync: this);

  /* NOTE 탭 인덱스 */
  int _tabIndex = 0;

  var _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    _tabs = [
      /* SECTION 첫 번쨰 탭 - 모니터링 */
      MonitorTab(),
      /* SECTION 두 번쨰 탭 - 기기 제어 */
      ControlTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // set max width of the app
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(color: $raonmoaColor),
            child: Image(image: AssetImage("assets/images/logo.png"), fit: BoxFit.fitHeight),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: $raonmoaColor,
        // no shadow and bottom border
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
        // settings page
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            // no ripple effect
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              // show settings as  bottomsheet
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => SettingsPage(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            color: $raonmoaColor,
            child: TabBar(
              tabs: [
                Tab(text: "홈"),
                Tab(text: "제어"),
              ],
              indicator: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                backgroundBlendMode: BlendMode.screen,
              ),
              labelStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.normal, color: Colors.white),
              labelColor: Colors.white,
              indicatorPadding: EdgeInsets.all(8),
              onTap: (index) => setState(() => _tabIndex = index),
              controller: _tabController,
              enableFeedback: true,
            ),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 000),
                  child: _tabs[_tabIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
