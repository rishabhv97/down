import 'package:flutter/material.dart';
import '../models/download_item.dart';

class DownloadProvider extends ChangeNotifier {
  // This list acts like a piece of state in React
  List<DownloadItem> _activeDownloads = [];

  List<DownloadItem> get activeDownloads => _activeDownloads;

  void addDownload(DownloadItem item) {
    _activeDownloads.add(item);
    notifyListeners(); // This tells the UI to re-render
  }

  void updateProgress(String id, double newProgress) {
    final index = _activeDownloads.indexWhere((item) => item.id == id);
    if (index != -1) {
      _activeDownloads[index].progress = newProgress;
      notifyListeners();
    }
  }
}