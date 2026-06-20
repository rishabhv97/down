import 'package:flutter/material.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // The _screens list now actually points to your newly built HomeScreen.
  final List<Widget> _screens = [
    HomeScreen(), // <-- Updated: Replaced placeholder with your actual screen
    const Center(child: Text('Downloads List', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Browser', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Files', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Profile', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The deep dark background color from your UI
      backgroundColor: const Color(0xFF0F111A), 
      
      body: _screens[_currentIndex],
      
      // Wrapping in a Theme to remove the default click splash ripple effect for a cleaner look
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF0F111A),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF7C3AED), // The premium purple/blue tint
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 8, // Adds a slight shadow above the nav bar
          
          items: [
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home_filled),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Badge(
                  label: const Text('2', style: TextStyle(fontSize: 10)),
                  backgroundColor: const Color(0xFF7C3AED),
                  child: const Icon(Icons.download_rounded),
                ),
              ),
              label: 'Downloads',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.language),
              ),
              label: 'Browser',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.folder_outlined),
              ),
              label: 'Files',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.person_outline),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}