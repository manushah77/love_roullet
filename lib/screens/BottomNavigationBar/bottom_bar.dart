
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:love_roulette/screens/BottomNavigationBar/BottomBarScreens/HistoryScreen/history_screen.dart';
import 'package:love_roulette/screens/BottomNavigationBar/BottomBarScreens/inbox/inbox.dart';
import 'package:love_roulette/screens/BottomNavigationBar/BottomBarScreens/profile/user_profile_screen.dart';
import '../HomeScreen/home_screen.dart';

class BottomBar extends StatefulWidget {
  int selectedIndex =0;
  BottomBar({required this.selectedIndex});
  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {

   // selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HistoryScreen(),
    InboxScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  // late PageController _pageController;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt( widget.selectedIndex),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.black,
        selectedIndex:  widget.selectedIndex,
        onItemSelected: (index) {
          setState(() =>  widget.selectedIndex = index);
          // _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Home',
                style: TextStyle(
                    color:  widget.selectedIndex == 0 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
                textScaleFactor: 1.0,
              ),
            ),
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:  widget.selectedIndex == 0
                    ? Colors.white
                    : Colors.grey.withOpacity(0.4),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/home.png',
                  scale: 4,
                  color:  widget.selectedIndex == 0 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),

          BottomNavyBarItem(
            activeColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'History',
                style: TextStyle(
                    color:  widget.selectedIndex == 1 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
                textScaleFactor: 1.0,

              ),
            ),
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:  widget.selectedIndex == 1
                    ? Colors.white
                    : Colors.grey.withOpacity(0.4),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/hist.png',
                  scale: 4,
                  color:  widget.selectedIndex == 1 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),

          BottomNavyBarItem(
            activeColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Inbox',
                style: TextStyle(
                    color:  widget.selectedIndex == 2 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
                textScaleFactor: 1.0,

              ),
            ),
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:  widget.selectedIndex == 2
                    ? Colors.white
                    : Colors.grey.withOpacity(0.4),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/msg.png',
                  scale: 4,
                  color:  widget.selectedIndex == 2 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),

          BottomNavyBarItem(
            activeColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Profile',
                style: TextStyle(
                    color:  widget.selectedIndex == 3 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
                textScaleFactor: 1.0,
              ),
            ),
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:  widget.selectedIndex == 3
                    ? Colors.white
                    : Colors.grey.withOpacity(0.4),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/profile.png',
                  scale: 4,
                  color:  widget.selectedIndex == 3 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
