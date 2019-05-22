import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

// 引入页面
import '../pages/details_page.dart';

// 页面控制器
Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String goodsId = params['id'].first;
    return DetailsPage(goodsId: goodsId);
  },
);
