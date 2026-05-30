import 'package:flutter/material.dart';
import 'dart:async';
import '../models/download_item.dart';

class DownloadProvider extends ChangeNotifier {
  final List<DownloadItem> _activeDownloads = [];

  List<DownloadItem> get activeDownloads => _activeDownloads;

  void startNewDownload(String url) {
    // 1. Create a new mock download item
    final newItem = DownloadItem(
      id: DateTime.now().toString(),
      title: 'video_from_$url.mp4',
      format: 'MP4',
      resolution: '1080p',
      fileSize: 'Calculating...',
      thumbnail: '', // We will leave this blank for the mock
      progress: 0.0,
    );

    // 2. Add to our list and tell the UI to re-render
    _activeDownloads.insert(0, newItem);
    notifyListeners();

    // 3. Simulate a network download (updates progress every 100ms)
    _simulateDownload(newItem.id);
  }

  void _simulateDownload(String id) {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final index = _activeDownloads.indexWhere((item) => item.id == id);
      if (index != -1) {
        if (_activeDownloads[index].progress >= 1.0) {
          timer.cancel(); // Stop when it hits 100%
        } else {
          _activeDownloads[index].progress += 0.02; // Add 2% progress
          if (_activeDownloads[index].progress > 1.0) {
            _activeDownloads[index].progress = 1.0;
          }
          notifyListeners(); // Update the progress bar in the UI
        }
      } else {
        timer.cancel();
      }
    });
  }
}