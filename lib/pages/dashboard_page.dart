import 'package:auth_app/pages/profile_page.dart';
import 'package:auth_app/pages/home_page.dart';
import 'package:auth_app/pages/savings_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedPageIndex = 0;
  String _selectedPageName = "Members";

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedPageIndex = index;
      switch (index) {
        case 0:
          _selectedPageName = "Members";
          break;
        case 1:
          _selectedPageName = "Savings";
          break;
        case 2:
          _selectedPageName = "Profile";
          break;
      }
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    const SavingsPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      appBar: AppBar(
        title: Center(
          child: Text(
            _selectedPageName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Members'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: 'Savings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
