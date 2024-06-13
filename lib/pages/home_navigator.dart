import 'package:flutter/material.dart';
import 'package:notes_app/pages/z_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _index = 0;

  bool isDark = false;

  void onTapHandler(int value){
    setState(() {
      _index = value;
    });
  }

  void changeTheme(){
    setState(() {
      isDark = !isDark;
    });
  }

   List<Widget> pages = [
     const MainPage(),
     const SearchPage(),
     const ProfilePage(),
     const SettingPage(),
  ];

  

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 33,
                    backgroundColor: colorScheme.onSecondary,
                    child: Image.asset('assets/images/profile.png', width: 50, height: 50,),
                  ),
                  const SizedBox(height: 10),
                  const Text('Fajar Spakbor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            ListTile(
              title: const Text('item 1'),
              onTap: (){},
            ),
            ListTile(
              title: const Text('item 1'),
              onTap: (){},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: pages[_index],
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_rounded), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (value) {
          onTapHandler(value);
        },
        currentIndex: _index,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

