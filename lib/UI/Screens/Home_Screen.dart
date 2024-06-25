import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  Duration _duration = const Duration(hours: 24, minutes: 23, seconds: 12);
  late TabController _tabController;
  List<bool> _isSelected = [true, false, false, false];

  @override
  void initState() {
    super.initState();
    _startTimer();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = _duration - const Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void _handleTabSelection() {
    // Update selected tab state when the tab changes
    setState(() {
      _isSelected = List.generate(4, (index) => index == _tabController.index);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: ImageIcon(
            const AssetImage('assets/icons/back_icon.png'),
            color: const Color(0xffFF5030),
            size: 40.sp,
          ),
        ),
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'المزاد',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: ImageIcon(
              const AssetImage('assets/icons/help_icon.png'),
              color: const Color(0xffFF5030),
              size: 40.sp,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Titles Exhibition.png',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 70.h),
                        Image(
                          image: const AssetImage('assets/images/ring.png'),
                          width: 137.w,
                          height: 119.h,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              color: const Color(0xff362550),
                            ),
                            child: Column(
                              children: [
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildTimeColumn(
                                        value: twoDigits(_duration.inHours),
                                        label: 'ساعه',
                                      ),
                                      SizedBox(width: 8.w),
                                      _buildTimeColumn(
                                        value: twoDigits(_duration.inMinutes.remainder(60)),
                                        label: 'دقيقه',
                                      ),
                                      SizedBox(width: 8.w),
                                      _buildTimeColumn(
                                        value: twoDigits(_duration.inSeconds.remainder(60)),
                                        label: 'ثانيه',
                                        showColon: false,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  'خاتم النجوم الأخضر الزيتي',
                                  style: TextStyle(
                                    fontSize: 23.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 90.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.r),
                                    color: const Color(0xffFF5030),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xffFF5030).withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: Offset(0, 3),
                                        )
                                      ]
                                  ),
                                  child: Text(
                                    'أضف عرضك الآن!',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      tabs: [
                        _buildTab('خاتم', _isSelected[0]),
                        _buildTab('أشياء مميزة', _isSelected[1]),
                        _buildTab('إطارات شخصية', _isSelected[2]),
                        _buildTab('زينة', _isSelected[3]),
                      ],
                      controller: _tabController,
                      labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
                      unselectedLabelColor: const Color(0xff392752),
                      isScrollable: true,
                      indicator: BoxDecoration(border: Border.all(color: Colors.transparent), color: Colors.transparent),
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 0,
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  ),
                )
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  TabScreen1(duration: _duration),
                  TabScreen1(duration: _duration),
                  TabScreen1(duration: _duration),
                  TabScreen1(duration: _duration),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: isSelected ? Colors.white : const Color(0xff37254F),
        border: Border.all(color: const Color(0xff37254F), width: 1),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h), // Adjusted padding
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xff37254F) : Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

Widget _buildTimeColumn({
  required String value,
  required String label,
  bool showColon = true,
}) {
  return Column(
    children: [
      Text(
        showColon ? '$value:' : value,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFFDCB0C),
          fontFamily: 'Tajawal',
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xffB38D27),
          fontFamily: 'Tajawal',
        ),
      ),
    ],
  );
}

class TabScreen1 extends StatelessWidget {
  final Duration duration;

  const TabScreen1({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          children: [
            Container(
              height: 380.h,
              width: 372.w,
              decoration: BoxDecoration(
                color: const Color(0xff3A2854),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const Image(image: AssetImage('assets/images/product.png')),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildTimeColumn(
                                  value: twoDigits(duration.inHours),
                                  label: 'ساعه',
                                ),
                                SizedBox(width: 4.w),
                                _buildTimeColumn(
                                  value: twoDigits(duration.inMinutes.remainder(60)),
                                  label: 'دقيقه',
                                ),
                                SizedBox(width: 4.w),
                                _buildTimeColumn(
                                  value: twoDigits(duration.inSeconds.remainder(60)),
                                  label: 'ثانيه',
                                  showColon: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      height: 92.h,
                      width: 340.w,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff422F5E),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'خاتم النجم المضيء',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Tajawal',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Text(
                                      'أعلى عرض حالياً',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xffB7B0C2),
                                        fontFamily: 'Tajawal',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 4.w),
                                    ImageIcon(
                                      const AssetImage('assets/icons/coin.png'),
                                      color: const Color(0xffFDCB0C),
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '83k',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xffFFD332),
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal:8.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.r),
                                    color: const Color(0xffFF5030),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffFF5030).withOpacity(0.2),
                                        spreadRadius: 4,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      )
                                    ]
                                ),
                                child: Text(
                                  'أضف عرضك الآن!',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 380.h,
              width: 372.w,
              decoration: BoxDecoration(
                color: const Color(0xff3A2854),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const Image(image: AssetImage('assets/images/product.png')),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildTimeColumn(
                                  value: twoDigits(duration.inHours),
                                  label: 'ساعه',
                                ),
                                SizedBox(width: 4.w),
                                _buildTimeColumn(
                                  value: twoDigits(duration.inMinutes.remainder(60)),
                                  label: 'دقيقه',
                                ),
                                SizedBox(width: 4.w),
                                _buildTimeColumn(
                                  value: twoDigits(duration.inSeconds.remainder(60)),
                                  label: 'ثانيه',
                                  showColon: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      height: 92.h,
                      width: 340.w,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff422F5E),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'خاتم النجم المضيء',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Tajawal',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Text(
                                      'أعلى عرض حالياً',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xffB7B0C2),
                                        fontFamily: 'Tajawal',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 4.w),
                                    ImageIcon(
                                      const AssetImage('assets/icons/coin.png'),
                                      color: const Color(0xffFDCB0C),
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '83k',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xffFFD332),
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal:8.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.r),
                                    color: const Color(0xffFF5030),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffFF5030).withOpacity(0.2),
                                        spreadRadius: 4,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      )
                                    ]
                                ),
                                child: Text(
                                  'أضف عرضك الآن!',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

