import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo = null;

  bool isLeft = true;
  bool isRight = false;

  // 从后台获取商品数据
  setGoodsInfo(String id) async{
    var params = {'goodId': id};
    await request('getGoodsDetailById', formData: params).then((val) {
      var res = json.decode(val.toString());
      goodsInfo = DetailsModel.fromJson(res);
      notifyListeners();
    });
  }

  // tabbar 的切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    }else{
      isLeft = false;
      isRight = true;
    }

    notifyListeners();
  }
}
