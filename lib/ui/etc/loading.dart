import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double _opacity = 0;
  // show 로딩중입니다 after 5 seconds

  @override
  void initState() {
    super.initState();
    _opacity = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // make sure  to consider dispose error
    Future.delayed(Duration(milliseconds: 5000), () {
      if (!mounted) return;
      setState(() {
        _opacity = 1;
      });
    });

    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Text('데이터 로딩중입니다. \n계속 로딩중인 경우 데이터가 없을 수 있습니다.'),
            )
          ],
        ),
      ),
    );
  }
}
