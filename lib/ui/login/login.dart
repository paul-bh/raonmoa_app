import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raonmoa_app/logics/design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raonmoa_app/ui/home.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // make input controller
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _autoLogin = false;
  double _opacity = 0;
  double _waveOpacity = 0;
  bool _isLoggingIn = false;
  bool _isAutoLoggingIn = false;
  late SharedPreferences prefs;
  var error;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    // prefs
    prefs = await SharedPreferences.getInstance();
    _autoLogin = prefs.getBool('autoLogin') ?? false;
    setState(() {
      _waveOpacity = 1;
    });

    if (_autoLogin) {
      setState(() {
        _isAutoLoggingIn = true;
      });
      // wait 1 second
      await Future.delayed(Duration(milliseconds: 1000));
      // check if user is properly logged in
      try {
        await FirebaseAuth.instance.currentUser!.reload();
      } catch (e) {
        error = e;
      }
      if (FirebaseAuth.instance.currentUser != null && error == null) {
        // pushreplacement to RaonmoaHome with fade transition
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => RaonmoaHome(),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('자동 로그인에 실패했습니다. ', style: TextStyle(color: Colors.black)),
            // style snackbar
            backgroundColor: Colors.white.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
        setState(() {
          _isAutoLoggingIn = false;
          prefs.setBool('autoLogin', false);
        });
      }
    } else {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그아웃되었습니다. ', style: TextStyle(color: Colors.black)),
            // style snackbar
            backgroundColor: Colors.white.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      } else {}
      setState(() {
        _isAutoLoggingIn = false;
      });
    }
    await Future.delayed(Duration(milliseconds: 600));
    if (mounted)
      setState(() {
        _opacity = 1;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // gradient background
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [$raonmoaColor.withOpacity(0.9), $raonmoaColor.withOpacity(1)],
              ),
            ),
            child: AnimatedOpacity(
              opacity: _waveOpacity,
              duration: Duration(milliseconds: 1000),
              child: WaveWidget(
                isLoop: true,
                config: CustomConfig(
                  durations: [4000, 5000, 6000],
                  heightPercentages: [0.1, 0.7, 0.8],
                  blur: MaskFilter.blur(BlurStyle.normal, 1),
                  colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.1)],
                ),
                waveAmplitude: 0,
                waveFrequency: 1,
                size: Size(double.infinity, double.infinity),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: _isLoggingIn
                        ? CircularProgressIndicator(color: Colors.white)
                        : Column(
                            children: [
                              // logo
                              Container(
                                width: 150,
                                child: Image(image: AssetImage("assets/images/logo.png"), fit: BoxFit.fitHeight),
                              ),
                              SizedBox(height: 40),
                              // email input
                              Container(
                                // style is white border
                                width: 400,
                                padding: const EdgeInsets.symmetric(horizontal: 38.0),

                                child: LoginTextField(hintText: '이메일', controller: _emailController),
                              ),
                              SizedBox(height: 10),
                              // password input
                              Container(
                                width: 400,
                                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                                child: LoginTextField(hintText: '비밀번호', controller: _passwordController),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 400,
                                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                                child: ElevatedButton(
                                  onLongPress: null,
                                  onHover: null,
                                  onFocusChange: null,
                                  onPressed: () async {
                                    // firebase login try
                                    // validator
                                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('이메일과 비밀번호를 입력해주세요.', style: TextStyle(color: Colors.black)),
                                          // style snackbar
                                          backgroundColor: Colors.white.withOpacity(0.9),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        ),
                                      );
                                      return;
                                    }
                                    // email validator
                                    if (!_emailController.text.contains('@')) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('이메일 형식이 올바르지 않습니다.', style: TextStyle(color: Colors.black)),
                                          // style snackbar
                                          backgroundColor: Colors.white.withOpacity(0.9),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        ),
                                      );
                                      return;
                                    }
                                    _login(_emailController.text, _passwordController.text);
                                  },
                                  child: Text('로그인'),
                                  style: ElevatedButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                                    disabledForegroundColor: Colors.white,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                              // 체크박스: 정보 저장, 자동 로그인
                              // keep the style from login button
                              // login button
                              Container(
                                width: 400,
                                //color: Colors.green,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      // keep outline color white
                                      side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                      value: _autoLogin,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      splashRadius: 0,
                                      onChanged: (value) {
                                        setState(() {
                                          _autoLogin = value!;
                                        });
                                      },
                                    ),
                                    InkWell(
                                        child: Text('자동 로그인', style: TextStyle(color: Colors.white)),
                                        onTap: () {
                                          setState(() {
                                            _autoLogin = !_autoLogin;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          _isAutoLoggingIn
              ? Center(
                  child: Text(
                  '자동 로그인 중입니다.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ))
              : Container(),
        ],
      ),
    );
  }

  ErrorMsg(error) {
    if (error.code == 'user-not-found') {
      return '존재하지 않는 이메일입니다. ';
    } else if (error.code == 'wrong-password') {
      return '계정 정보가 올바르지 않습니다. ';
    } else if (error.code == 'invalid-email') {
      return '이메일 형식이 올바르지 않습니다. ';
    } else {
      return '알 수 없는 오류가 발생했습니다. ';
    }
  }

  TextFormField LoginTextField({hintText, controller}) {
    return TextFormField(
      // if enter, login
      onFieldSubmitted: (value) {
        // hide keyboard
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.done,
      // hide password
      obscureText: hintText == '비밀번호' ? true : false,
      enabled: _isLoggingIn ? false : true,
      style: TextStyle(color: Colors.black),
      obscuringCharacter: '•',
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (hintText == '이메일') {
            return '이메일을 입력해주세요.';
          } else if (hintText == '비밀번호') {
            return '비밀번호를 입력해주세요.';
          }
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        hoverColor: Colors.white.withOpacity(0.1),
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  void _login(String email, String password) async {
    setState(() {
      _isLoggingIn = true;
    });
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
        .then((value) async {
      prefs.setBool('autoLogin', _autoLogin);
      // go to home page, and remove all previous page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RaonmoaHome()),
        (route) => false,
      );
    }).catchError(
      (error) {
        // if login failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            //depend on error code
            content: Text(ErrorMsg(error), style: TextStyle(color: Colors.black)),
            // style snackbar
            backgroundColor: Colors.white.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        );
      },
    );
    setState(() {
      _isLoggingIn = false;
    });
  }
}
