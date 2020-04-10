import 'package:flutter/material.dart';
import 'package:youxinbao/res/colors.dart';
import '../../../../blocs/bloc_index.dart';
import '../../page_index.dart';

class ManagerMainPage extends StatefulWidget {
  ManagerMainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<ManagerMainPage> {
  int _currentIndex;
  List<Widget> _pages;
  PageController _controller;
    
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pages = [
      PlanIndexPage(),
      CustomerIndexPage(),
      FinanceIndexPage(),
      MpersonalPage(),
    ];
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.gray_cc,
      body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _pageChange,
          controller: _controller,
          itemCount: _pages.length,
          itemBuilder: (context, index) => _pages[index]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(ImgPrefix.manager_prefix + 'plan_icon.png',
                width: 22, height: 22),
            activeIcon: Image.asset(
                ImgPrefix.manager_prefix + 'plan_active_icon.png',
                width: 22,
                height: 22),
            title: Text('计划管理',
                style: TextStyle(
                    color: _currentIndex == 0
                        ? Colours.orange_72
                        : Colours.gray_66)),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(ImgPrefix.manager_prefix + 'mycustomer_icon.png',
                width: 22, height: 22),
            activeIcon: Image.asset(
                ImgPrefix.manager_prefix + 'mycustomer_active_icon.png',
                width: 22,
                height: 22),
            title: Text('我的客户',
                style: TextStyle(
                    color: _currentIndex == 1
                        ? Colours.orange_72
                        : Colours.gray_66)),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(ImgPrefix.manager_prefix + 'finance_icon.png',
                width: 22, height: 22),
            activeIcon: Image.asset(
                ImgPrefix.manager_prefix + 'finance_active_icon.png',
                width: 22,
                height: 22),
            title: Text('财务管理',
                style: TextStyle(
                    color: _currentIndex == 2
                        ? Colours.orange_72
                        : Colours.gray_66)),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(ImgPrefix.manager_prefix + 'mine_icon.png',
                width: 22, height: 22),
            activeIcon: Image.asset(
                ImgPrefix.manager_prefix + 'mine_active-icon.png',
                width: 22,
                height: 22),
            title: Text('我的',
                style: TextStyle(
                    color: _currentIndex == 3
                        ? Colours.orange_72
                        : Colours.gray_66)),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void onTap(int index) {
    _controller.jumpToPage(index);
  }

  void _pageChange(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
