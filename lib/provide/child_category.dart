import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 右侧顶部子类高亮索引
  String categoryId = '4'; // 大类id
  String subId = ''; // 子类id
  int page = 1; // 商品列表页码
  String noMoreText = ''; // 加载无数据文字

  // 设置大类id、子类组
  setChildgategory(String id, List<BxMallSubDto> list) {
    childIndex = 0;
    categoryId = id;
    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    // 全部+子类组
    childCategoryList.addAll(list);

    notifyListeners();
  }

  // 设置子类高亮索引
  setChildIndex(index, id) {
    page = 1;
    noMoreText = '';
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  addpage() {
    page++;
    // notifyListeners();  //无Widget变化可不通知
  }

  setNoMoreText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
