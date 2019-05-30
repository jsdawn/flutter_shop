import 'package:flutter/material.dart';

class CurrentIndexProvide with ChangeNotifier {
  int currentIndex = 0; //主页面的显示索引

  setIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }
}
