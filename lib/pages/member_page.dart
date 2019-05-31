import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

class MemberPage extends StatelessWidget {
  MemberPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('会员中心'),
        ),
        body: ListView(
          children: <Widget>[
            _topHeader(context),
            _orderTitle(),
            _orderType(),
            _actionList(),
          ],
        ),
      ),
    );
  }

  // 顶部头像
  Widget _topHeader(context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setWidth(200),
            child: ClipOval(
              child: Image.network(
                  'http://5b0988e595225.cdn.sohucs.com/images/20180720/9787561c8eaf42ddadb5a4e297c94838.jpeg'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '蝶',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 订单标题
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  // 订单导航列表
  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.payment, size: 30),
                Text('待付款'),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.query_builder, size: 30),
                Text('待发货'),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.directions_car, size: 30),
                Text('待收货'),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.content_paste, size: 30),
                Text('待评价'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 个人中心功能菜单
  Widget _myListTile(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.blur_circular),
        title: Text(title),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _actionList() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTile('领取优惠券'),
          _myListTile('已领取优惠券'),
          _myListTile('地址管理'),
          _myListTile('客服电话'),
          _myListTile('关于我们'),
        ],
      ),
    );
  }

  // end
}
