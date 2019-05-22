import 'package:flutter/material.dart';
import '../model/catagoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryGoodsListData> goodsList = [];

  // 点击大类时更换商品列表
  setGoodsList(List<CategoryGoodsListData> list) {
    goodsList = list;
    notifyListeners();
  }

  setMoreList(List<CategoryGoodsListData> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
