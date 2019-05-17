import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

// 通用请求接口
Future request(pathName, {formData}) async {
  try {
    print('请求接口 ($pathName) : ${servicePath[pathName]}');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if (formData == null) {
      response = await dio.post(servicePath[pathName]);
    } else {
      response = await dio.post(servicePath[pathName], data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('=> 后端接口出现异常 <=');
    }
  } catch (e) {
    return print('ERROR:===========> $e');
  }
}
