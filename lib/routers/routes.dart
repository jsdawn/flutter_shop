import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

// fluro 路由配置
class Routes {
  static String root = '/';

  static void configureRoutes(Router router) {
    // 404 page
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR===>ROUTE WAS NOT FONUND');
      },
    );
    // page's router
    router.define('/detail', handler: detailsHandler);
  }
}
