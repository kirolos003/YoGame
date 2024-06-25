
import 'package:flutter/material.dart';

import '../Network/local/cache_helper.dart';

class AppProvider extends ChangeNotifier {
  bool isDark = false;
  void changeAppTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      notifyListeners();
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark)
          .then((value) => notifyListeners());
    }
  }

  int current = 0;
  void refresh(int index){
    current = index;
    notifyListeners();
  }

  List<dynamic> tabs = ['خاتم' , 'أشياء مميزة' , 'إطارات شخصية'];

}

