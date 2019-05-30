import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('购物车'),
        ),
        body: FutureBuilder(
          future: _getCartInfo(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // List cartList = Provide.value<CartProvide>(context).cartList;
              return Stack(
                children: <Widget>[
                  // 列表
                  Provide<CartProvide>(
                    builder: (context, child, val) {
                      List cartList = Provide.value<CartProvide>(context).cartList;
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
                        itemCount: cartList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CartItem(
                            item: cartList[index],
                          );
                        },
                      );
                    },
                  ),

                  // 结算栏
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CartBottom(),
                  ),
                ],
              );
            } else {
              return Text('正在加载...');
            }
          },
        ),
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}
