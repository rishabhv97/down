import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const DownloaderApp());
}

class DownloaderApp extends StatelessWidget {
  const DownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Downloader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', // Or whichever clean sans-serif font you prefer
        brightness: Brightness.dark,
      ),
      home: const MainScreen(),
    );
  }
}