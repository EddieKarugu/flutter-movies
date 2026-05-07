import 'package:flutter/material.dart';

import 'homepage.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> _pages = [
    Homepage(),
    Text('Search'),
    Text('Downloads'),
    Text('Account'),
  ];

  final List<String> _titles = ['Home', 'Search', 'Downloads', 'Account'];
  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.download_outlined,
    Icons.account_circle_outlined,
  ];
  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.search,
    Icons.download,
    Icons.account_circle,
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWidescreen = size.width > 600;

    return Scaffold(
      drawer: !isWidescreen
          ? null
          : Drawer(
              child: Column(
                children: [
                  const Spacer(),
                  UserAccountsDrawerHeader(
                    accountName: Text('User-03052876'),
                    accountEmail: Text('unknown@gmail.com'),
                    currentAccountPicture: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/background.jpg'),
                    )
                  ),
                  const Spacer(),
                  ...List.generate(_pages.length, (index)=>ListTile(
                    selected: index == _selectedIndex,
                    leading: Icon(_icons[index]),
                    title: Text(_titles[index]),
                    onTap: (){
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  )),
                  const Spacer(),
                ],
              ),
            ),
      bottomNavigationBar: isWidescreen
          ? null
          : BottomNavigationBar(
              items: [
                ...List.generate(
                  _titles.length,
                  (index) => BottomNavigationBarItem(
                    icon: Icon(_icons[index]),
                    label: _titles[index],
                    activeIcon: Icon(_selectedIcons[index]),
                  ),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: Color(0xff0000ff),
              showUnselectedLabels: false,
              showSelectedLabels: true,
            ),
      body: Center(child: _pages[_selectedIndex]),
    );
  }
}
