import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo = null;

  // 从后台获取商品数据
  setGoodsInfo(String id) {
    var params = {'goodId': id};
    request('getGoodsDetailById', formData: params).then((val) {
      var res = json.decode(val.toString());
      print(res);
      goodsInfo = DetailsModel.fromJson(res);

      notifyListeners();
    });
  }
}
