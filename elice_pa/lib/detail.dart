import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailContentsView extends StatefulWidget {

  final String url;
  final String title;
  DetailContentsView({Key key, @required this.url, @required this.title}) : super(key: key);

  @override
  _DetailContentsViewState createState() => _DetailContentsViewState();
}

class _DetailContentsViewState extends State<DetailContentsView> {

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() { 
    super.initState();
  }

  loadContents(String url)
  async {
    var responseData = await http.get(url);
    var retData = jsonDecode(responseData.body);
    var listData = retData["courses"];
    return listData;
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
      return Image.network(url, height: 40, width: 40,);
    }
  }

  makeRecommendData(List<dynamic> datas, int index)
  {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffffffff),
        ),
        height: 120,
        width: 343,
        margin: EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xfff0f0f0),
              ),
              height: 88,
              width: 88,
              child: checkImageUrl(datas[index]["logo_file_url"]),
              margin: EdgeInsets.all(16),
            ),
            Container(
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 207,
                      height: 40,
                      margin: EdgeInsets.only(
                        top:18
                      ),
                      child: Text(
                        datas[index]["title"],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 207,
                      child: Text(
                        checkInstructors(datas[index]["instructors"]),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      height: 22,
                      width: 207,
                      child: Row(
                        children: [
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
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: ()
      {
        Container();
      },
    );
  }

  makeDataList(List<dynamic> datas)
  {
    return Container(
      height: MediaQuery.of (context) .size.height,
      color: Color(0xfff6f7f8),
      child:  ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: datas.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              makeRecommendData(datas, index),
            ]
          );
        },
      )
    );
  }

  Widget appBar(String title)
  {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Color(0xffffffff),
        onPressed: (){
          Navigator.pop(context);
        }
      ),
      backgroundColor: Color(0xff202044),
      centerTitle: true,
      title: Text(
        title, 
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xffffffff),
        )
      ),
    );
  }

  Widget bodyWidget(url)
  {
    return FutureBuilder(
      future: loadContents(url),
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

  Future reFresh()
  async {
    refreshKey.currentState?.show(atTop:false);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      bodyWidget(widget.url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.title),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: reFresh,
        child: bodyWidget(widget.url)
      ),
    );
  }
}