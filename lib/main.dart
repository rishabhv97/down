import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import 'screens/main_screen.dart';
import 'providers/download_provider.dart'; // Add this import

void main() {
  runApp(
    // Wrap the app in a MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ],
      child: const DownloaderApp(),
    ),
  );
}

class DownloaderApp extends StatelessWidget {
  const DownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Downloader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', 
        brightness: Brightness.dark,
      ),
      home: const MainScreen(),
    );
  }
}