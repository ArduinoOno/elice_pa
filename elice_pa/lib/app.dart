import 'package:elice_pa/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscan/qrscan.dart' as scanner; 
import 'dart:convert';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  int _currentPageIndex = 0;
  int defaultBottomNvColor = 0xff8d8a8a;
  int activeBottomNvColor = 0xff524aa1;

  @override
  void initState() { 
    super.initState();
    _currentPageIndex = 0;
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
      case 1:
        _currentPageIndex = 0;
        return Home();
        break;
      default:
      return Center(child: Text("공사중 입니다 에러."),);
    }
  }

  BottomNavigationBarItem _bottomNavigationBarAccount(String _labal, int defaultColor, int activeColor)
  {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/icon_action_account_balance_24px.svg", width: 19, height: 19.3, color: Color(defaultColor),),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/icon_action_account_balance_24px.svg", width: 22, height: 19.3, color: Color(activeColor),),
      ),
      label: _labal,
    );
  }

  BottomNavigationBarItem _bottomNavigationBarCam(String _labal, int defaultColor, int activeColor)
  {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/icon_image_camera_alt_24px.svg", width: 22, height: 19.3, color: Color(defaultColor),),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset("assets/svg/icon_image_camera_alt_24px.svg", width: 22, height: 19.3, color: Color(activeColor),),
      ),
      label: _labal,
    );
  }

  Widget _bottomNavigationBarWidget()
  {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index){
        if(index == 1)
        {
          _scan();
        }
        setState(() {
          _currentPageIndex = index;
        });
      },
      selectedFontSize: 12,
      currentIndex: _currentPageIndex,
      selectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(color: Colors.black),
      items: [
        _bottomNavigationBarAccount('Home', defaultBottomNvColor, activeBottomNvColor),
        _bottomNavigationBarCam('QR', defaultBottomNvColor, activeBottomNvColor),
      ],
    );
  }

  Future _scan() async {
    //스캔 시작 - 이때 스캔 될때까지 blocking
    String barcode = await scanner.scan();
    //스캔 완료하면 완료한 데이터로 브라우저 호출
    _launchURL(barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Codec<String, String> stringToBase64Url = utf8.fuse(base64);
      String deCodeUrl = stringToBase64Url.decode(url);
      if(await canLaunch(deCodeUrl))
      {
        await launch(deCodeUrl);
      }
      else
      {
        await launch("https://www.naver.com/");
      }
    }
  }
}