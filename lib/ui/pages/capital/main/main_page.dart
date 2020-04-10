import 'package:flutter/material.dart';
import 'package:youxinbao/res/colors.dart';
import '../manage/manage_whole.dart';
import '../../page_index.dart';
import 'package:youxinbao/ui/pages/capital/account/account_middle.dart';

class CapitalMainPage extends StatefulWidget {
  CapitalMainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CapitalMainPage();
}

class _CapitalMainPage extends State<CapitalMainPage>{
  int _currentIndex;
  List<Widget> _pages;
  PageController _controller;
  bool isBottomChanged = false;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pages = [
      ManagePage(),
      AccountPage(),
      CapicalMinePage(),
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
      body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _pageChange,
          controller: _controller,
          itemCount: _pages.length,
          itemBuilder: (context, index) => _pages[index]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/images/capital/plan.png'),
              width: 22,
              height: 22,
            ),
            activeIcon: Image(
              image: AssetImage('assets/images/capital/plan_active.png'),
              width: 22,
              height: 22,
            ),
            title: Text(
              '计划管理',
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/images/capital/account.png'),
              width: 22,
              height: 22,
            ),
            activeIcon: Image(
              image: AssetImage('assets/images/capital/account_selected.png'),
              width: 22,
              height: 22,
            ),
            title: Text(
              '对账中心',
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/images/capital/mine.png'),
              width: 22,
              height: 22,
            ),
            activeIcon: Image(
              image: AssetImage('assets/images/capital/mine_selected.png'),
              width: 22,
              height: 22,
            ),
            title: Text(
              '我的',
            ),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onTap,
      ),
    );
  }

  void onTap(int index) {
    if (index == 1 || index == 2) {
      isBottomChanged = true;
    }
    if (index == 0) {
      if (isBottomChanged) {
        eventBus.fire(OpenStatusEvent());
        isBottomChanged = false;
      }
    }
    if (index == 1) {
      accountEventBus.fire(TabStatus(true));
    } else {
      accountEventBus.fire(TabStatus(false));
    }
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
