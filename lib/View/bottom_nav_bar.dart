import 'package:expanse_manager/Utils/colors.dart';
import 'package:expanse_manager/View/home_screen.dart';
import 'package:expanse_manager/View/profile_screen.dart';
import 'package:expanse_manager/View/statistics_screen.dart';
import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // List<Widget> _buildScreen() {
  //   return [
  //     HomeScreen(),
  //     Center(child: Text('Statistics')),
  //     // Text('Home'),
  //     // AddTransactionScreen(myCategory: dataSingleton.mcategories),
  //     Center(child: Text('Wallet')),
  //     ProfileScreen(),
  //   ];
  // }

  // List<PersistentBottomNavBarItem> navbarItem() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(
  //         Icons.home,
  //       ),
  //       activeColorPrimary: ThemeColor1,
  //       inactiveIcon: const Icon(
  //         Icons.home_outlined,
  //         color: Colors.grey,
  //       ),
  //     ),
  //     PersistentBottomNavBarItem(
  //         icon: const Icon(
  //           Icons.signal_cellular_alt,
  //         ),
  //         activeColorPrimary: ThemeColor1,
  //         inactiveIcon: const Icon(
  //           Icons.signal_cellular_alt,
  //           color: Colors.grey,
  //         )),
  //     PersistentBottomNavBarItem(
  //         icon: const Icon(
  //           Icons.credit_card,
  //         ),
  //         activeColorPrimary: ThemeColor1,
  //         inactiveIcon:const Icon(
  //           Icons.credit_card,
  //           color: Colors.grey,
  //         )),
  //     PersistentBottomNavBarItem(
  //         icon: const Icon(
  //           Icons.person_2,
  //         ),
  //         activeColorPrimary: ThemeColor1,
  //         inactiveIcon: const Icon(
  //           Icons.person_2_outlined,
  //           color: Colors.grey,
  //         )),
  //   ];
  // }

  int _currentIndex = 0;
  final tabs = [
    HomeScreen(),
    const Center(
      child: StatisticsScreen(),
    ),
    const Center(
      child: Text('Wallet'),
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.home,
              color: ThemeColor1,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            label: 'Statistics',
            icon: const Icon(
              Icons.signal_cellular_alt,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.signal_cellular_alt,
              color: ThemeColor1,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Wallet',
            icon: const Icon(
              Icons.credit_card,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.credit_card,
              color: ThemeColor1,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.person,
              color: ThemeColor1,
            ),
          ),
        ],
      ),
    );
    // PersistentTabView(
    //   context,
    //   screens: _buildScreen(),
    //   items: navbarItem(),
    //   backgroundColor: white,
    //   decoration: NavBarDecoration(
    //     borderRadius: BorderRadius.circular(1),
    //   ),
    //   navBarStyle: NavBarStyle.style11,
    // );
  }
}
