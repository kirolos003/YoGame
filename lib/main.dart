// ignore_for_file: no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sample/Network/local/cache_helper.dart';
import 'package:sample/UI/Screens/Home_Screen.dart';
import 'package:sample/style/themes.dart';
import 'Provider/appProvider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool? isDark = await CacheHelper.getData(key: 'isDark');
  String? isEnglish = await CacheHelper.getData(key: 'isEnglish');
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => AppProvider()
        ..changeAppTheme(fromShared: isDark),
      child: MyApp(
        isDark: isDark,
        isEnglish: isEnglish,
      )));


}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final String? isEnglish;
  const MyApp(
      {
        super.key, required this.isDark,
        required this.isEnglish,
        });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return ScreenUtilInit(
      designSize: const Size(430,932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: provider.isDark ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}



