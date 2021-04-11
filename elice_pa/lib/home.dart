import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detail.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String paUrl = "https://api-rest.elice.io/org/academy/course/list/";
  String makeUrl_1;
  String makeUrl_2;
  String recommendTitle = "추천 과목";
  String freeTitle = "무료 과목";

  Widget appBar()
  {
    return AppBar(
      title: Image.asset("assets/titleLogo/elice pupple logo.jpg", width: 108, height: 32,),
      centerTitle: true,
      actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/svg/icon_social_notifications_24px.svg",
            ), 
            onPressed: null
          ),
        ],
    );
  }

  @override
  void initState() { 
    super.initState();
    makeUrl_1 = "${paUrl}?filter_is_free=false&filter_is_recommended=true&offset=0&count=10";
    makeUrl_2 = "${paUrl}?filter_is_free=true&filter_is_recommended=false&offset=0&count=10";
  }

  // API 호출하여 데이터 1차 가공하여 리턴
  loadContents()
  async {
    var responseDataRecommend = await http.get(makeUrl_1);
    var responseDataFree = await http.get(makeUrl_2);
    var recommendBodyData = jsonDecode(responseDataRecommend.body);
    var freeBodyData = jsonDecode(responseDataFree.body);
    var retData = [recommendBodyData['courses'], freeBodyData['courses']];
    return retData;
  }

  checkInstructors(List<dynamic> instructorsData)
  {
    if(instructorsData.length < 1)
    {
      return "선생님 미등록";
    }
    else
    {
      return instructorsData[0]['fullname'];
    }
  }

  checkImageUrl(String url)
  {
    if(url == null)
    {
      return Image.asset("assets/defaultLogo/flutter.png");
    }
    else
    {
      return Image.network(url);
    }
  }

  /**
   * 리스트를 작성하는 함수
   */
  makeRecommendData(List<dynamic> recommendData, int index)
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff938dd0),
      ),
      height: 200,
      width: 160,
      child: Column(
        children: [
          SizedBox(height: 17,),
          Container(
            width: 44,
            height: 44,
            child: checkImageUrl(recommendData[index]["logo_file_url"]),
            color: Color(0xfff0f0f0),
          ),
          SizedBox(height: 4,),
          Container(
            width: 136,
            height: 50,
            child: Text(
              recommendData[index]["title"],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xffffffff)
              ),
            ),
          ),
          SizedBox(height: 21,),
          Container(
            height: 64,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(10),
              ),
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    checkInstructors(recommendData[index]["instructors"]), 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  margin: EdgeInsets.all(5),
                ),
                Container(
                  height: 22,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Color(0xff0078b5),
                  ),
                  child: Center(
                    child: Text(
                      "오프라인", 
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xfff6f7f8)),
                    ),
                  ),
                  margin: EdgeInsets.all(5),
                )
              ],
            ),
          ),
        ]
      ),
    );
  }

  // API의 리턴값을 받아 1차가공한 값을 바탕으로 본격적인 리스트를 작성하는 함수
  // height: MediaQuery.of (context) .size.height,
  makeDataList(List<dynamic> datas)
  {
    List<dynamic> recommendData = datas[0];
    List<dynamic> freeData = datas[1];
    return SingleChildScrollView(
      child: InkWell(
        child: Container(
          height: MediaQuery.of (context) .size.height,
          color: Color(0xfff6f7f8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 22,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 16,),
                  Text(recommendTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),),
                  Spacer(),
                  InkWell(
                    child: Text("전체 보기", style: TextStyle(fontSize: 10, color: Color(0xff564ea9))),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return DetailContentsView(url: makeUrl_1, title: recommendTitle,);
                      }));
                    },
                  ),
                  SizedBox(width: 16,),
                ]
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  itemCount: recommendData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        makeRecommendData(recommendData, index),
                        SizedBox(width: 13,),
                      ]
                    );
                  },
                )
              ),
              SizedBox(height: 22,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 16,),
                  Text(freeTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),),
                  Spacer(),
                  InkWell(
                    child: Text("전체 보기", style: TextStyle(fontSize: 10, color: Color(0xff564ea9))),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return DetailContentsView(url: makeUrl_2, title: freeTitle,);
                      }));
                    },
                  ),
                  SizedBox(width: 16,),
                ]
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  itemCount: freeData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        makeRecommendData(freeData, index),
                        SizedBox(width: 13,),
                      ]
                    );
                  },
                )
              ),
              SizedBox(height: 22,),
            ]
          ),
        ),
        onTap: ()
        {
          Container();
        },
      ),
    );
  }

  Widget bodyWidget()
  {
    return FutureBuilder(
      future: loadContents(),
      builder: (context, snapshot) {

        if(snapshot.hasError) {
          return Center(child: Text("오류 문의 부탁드립니다."),);
        }

        if(snapshot.hasData) {
          return makeDataList(snapshot.data);
        }

        return Center(child: Text("데이터를 불러오는 중입니다."),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: bodyWidget(),
    );
  }
}