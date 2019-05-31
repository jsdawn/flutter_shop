import 'package:flutter/material.dart';
// import 'package:provide/provide.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  // 状态部分
  String cartString = '[]'; //购物车商品列表字符串
  List<CartInfoModel> cartList = []; //购物车商品列表
  double allPrice = 0.00; //选中总价格
  int allGoodsCount = 0; //选中总数量
  bool isAllCheck = true; //是否全选

  // 函数部分
  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo'); //获取持久化存储的值
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    //声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; //默认为没有
    int ival = 0; //用于进行循环的索引使用
    tempList.forEach((item) {
      // 同步已有数据到list
      cartList.add(new CartInfoModel.fromJson(item));
      //如果存在，数量进行+1操作
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }
      ival++;
    });
    //  如果没有，进行增加
    if (!isHave) {
      //关键代码-----------------start
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true
      };
      tempList.add(newGoods);
      cartList.add(new CartInfoModel.fromJson(newGoods));
      //关键代码-----------------end
    }
    //把字符串进行encode操作，
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString); //进行持久化
    await getCartInfo();
  }

  // 清空购物车
  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    print('清空完成====');
    await getCartInfo();
  }

  // 查询
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    // 初始化
    cartList = [];
    allPrice = 0.00;
    allGoodsCount = 0;
    // 重新赋值
    if (cartString != null) {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      isAllCheck = true;
      tempList.forEach((item) {
        if (item['isCheck']) {
          allPrice += (item['count'] * item['price']);
          allGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(new CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  // 删除单个购物车商品
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt((delIndex));
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 单项复选框选择
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 全选复选框
  changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];
    for (var item in tempList) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }
    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 商品数量加减
  addOrReduceAction(var cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    if (todo == 'add') {
      cartItem.count++;
    } else if (todo == 'reduce' && cartItem.count > 1) {
      cartItem.count--;
    }
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // end
}
