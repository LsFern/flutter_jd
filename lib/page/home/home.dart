import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jd/model/home/shop_list_model.dart';
import 'package:flutter_jd/model/home/swiper_model.dart';
import 'package:flutter_jd/page/home/widget/like_list.dart';
import 'package:flutter_jd/page/home/widget/swpier.dart';
import 'package:flutter_jd/utils/http_util.dart';
import 'package:flutter_jd/utils/screen_util.dart';
import 'package:flutter_jd/widget/cache_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SwiperModel homeSwiperModel;

  // 猜你喜欢
  ShopList hotList;

  // 热门推荐
  ShopList bestList;

  @override
  void initState() {
    super.initState();
    getSwiperData();
    geBestData();
    getHotData();
  }

  getSwiperData() async {
    var response = await HttpUtils.sendRequest('/focus',
        params: null, way: RequestWay.get);
    setState(() {
      homeSwiperModel = SwiperModel.fromJson(response);
    });
  }

  geBestData() async {
    String url = '/plist?is_best=1';
    var response =
        await HttpUtils.sendRequest(url, params: null, way: RequestWay.get);
    setState(() {
      bestList = ShopList.fromJson(response);
    });
  }

  getHotData() async {
    String url = '/plist?is_hot=1';
    var response =
        await HttpUtils.sendRequest(url, params: null, way: RequestWay.get);
    setState(() {
      hotList = ShopList.fromJson(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                HomeSwiper(
                  swiperList: homeSwiperModel?.result ?? [],
                ),
                SizedBox(height: ScreenUtils.setWidth(30),),
                _shopContainer(),
                LikeList(list: hotList.result,),
                SizedBox(height: ScreenUtils.setWidth(10),),
                _shopContainer(isHot: false),
              ],
            ),
          )),
    );
  }

  Widget _shopContainer({bool isHot = true}) {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtils.setWidth(20),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    width: ScreenUtils.setWidth(10), color: Colors.red))),
        child: Text(
          '${isHot ? '猜你喜欢' : '热门推荐'}',
          style:
              TextStyle(fontSize: ScreenUtils.setSp(27), color: Colors.red,fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
