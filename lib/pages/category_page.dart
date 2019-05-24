import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/catagoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 左侧导航菜单
class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1, color: Colors.black12)),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((res) {
      var data = json.decode(res.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
        Provide.value<ChildCategory>(context)
            .setChildgategory(list[listIndex].mallCategoryId, list[listIndex].bxMallSubDto);
        _getGoodsList(categoryId: list[listIndex].mallCategoryId);
      });
    });
  }

  // 获取大类的全部商品
  void _getGoodsList({String categoryId}) async {
    var params = {
      'categoryId': categoryId,
      'categorySubId': '',
      'page': 1,
    };
    await request('getMallGoods', formData: params).then((res) {
      var data = json.decode(res.toString());
      CategoryGoodsListModel categoryGoods = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).setGoodsList(categoryGoods.data);
    });
  }

  Widget _leftInkWell(int index) {
    CategoryModelData item = list[index];
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;

    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = item.bxMallSubDto;
        var categoryId = item.mallCategoryId;
        Provide.value<ChildCategory>(context).setChildgategory(categoryId, childList);
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Text(
          item.mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

// 右侧顶部类别
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (BuildContext context, Widget child, value) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: value.childCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return _rightInkWell(index, value.childCategoryList[index]);
            },
          ),
        );
      },
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex) ? true : false;
    // 获取相应子类的商品列表
    void _getGoodsList() {
      var params = {
        'categoryId': Provide.value<ChildCategory>(context).categoryId,
        'categorySubId': Provide.value<ChildCategory>(context).subId,
        'page': 1,
      };
      request('getMallGoods', formData: params).then((res) {
        var data = json.decode(res.toString());
        CategoryGoodsListModel categoryGoods = CategoryGoodsListModel.fromJson(data);
        if (categoryGoods.data == null) {
          Provide.value<CategoryGoodsListProvide>(context).setGoodsList([]);
        } else {
          Provide.value<CategoryGoodsListProvide>(context).setGoodsList(categoryGoods.data);
        }
      });
    }

    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context).setChildIndex(index, item.mallSubId);
        _getGoodsList();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isClick ? Colors.pink : Colors.black,
          ),
        ),
      ),
    );
  }
}

// 商品列表，上拉加载
class CategoryGoodsList extends StatefulWidget {
  CategoryGoodsList({Key key}) : super(key: key);

  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  var scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, value) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            // 列表位置滚动到顶部
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化');
        }

        if (value.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  loadText: '上拉加载',
                  loadReadyText: '释放立即加载',
                  loadingText: '加载中...',
                  loadedText: '加载完成',
                  // noMoreText 插件bug 无法正确判断无数据状态 - 状态管理 手动更改状态
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  // noMoreText: '没数据',
                  // moreInfo: '',
                ),
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: value.goodsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _listItem(value.goodsList, index);
                  },
                ),
                loadMore: () async {
                  _getMoreList();
                },
              ),
            ),
          );
        } else {
          return Center(
            child: Text('暂无数据'),
          );
        }
      },
    );
  }

  void _getMoreList() {
    Provide.value<ChildCategory>(context).addpage();
    var params = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page,
    };
    request('getMallGoods', formData: params).then((res) {
      var data = json.decode(res.toString());
      CategoryGoodsListModel categoryGoods = CategoryGoodsListModel.fromJson(data);
      if (categoryGoods.data == null) {
        Fluttertoast.showToast(
          msg: '已经到底啦~',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Provide.value<ChildCategory>(context).setNoMoreText('没有更多数据了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context).setMoreList(categoryGoods.data);
      }
    });
  }

  // 列表布局
  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style: TextStyle(
              color: Colors.pink,
              fontSize: ScreenUtil().setSp(30),
            ),
          ),
          Expanded(
            child: Text(
              '价格：￥${newList[index].oriPrice}',
              style: TextStyle(
                color: Colors.black26,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItem(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Colors.black12,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            )
          ],
        ),
      ),
    );
  }
}
