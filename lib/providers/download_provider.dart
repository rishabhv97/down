import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import '../models/download_item.dart';

class DownloadProvider extends ChangeNotifier {
  final List<DownloadItem> _activeDownloads = [];
  final Dio _dio = Dio();
  
  // YOUR NEW VERCEL URL GOES HERE!
  final String _apiUrl = 'https://downloader-api-murex.vercel.app/api/extract';

  List<DownloadItem> get activeDownloads => _activeDownloads;

  Future<void> startNewDownload(String originalUrl) async {
    print("--- DEBUG: startNewDownload triggered! ---");
    
    // 1. Request Gallery Permission first
    print("--- DEBUG: Requesting permissions... ---");
    final hasPermission = await _requestPermissions();
    print("--- DEBUG: Permission granted? $hasPermission ---");
    
    if (!hasPermission) {
      print("--- DEBUG: Stopped because permissions were false. ---");
      return; 
    }

    // 2. Create a placeholder item
    print("--- DEBUG: Adding item to UI ---");
    final itemId = DateTime.now().millisecondsSinceEpoch.toString();
    final newItem = DownloadItem(
      id: itemId,
      title: 'Extracting video...',
      format: '...',
      resolution: '...',
      fileSize: '...',
      thumbnail: '',
      progress: 0.0,
    );
    
    _activeDownloads.insert(0, newItem);
    notifyListeners();

    try {
      print("--- DEBUG: Sending request to Vercel... ---");
      // 3. Ask your Vercel API for the direct MP4 link
      final response = await _dio.post(
        _apiUrl,
        data: {'url': originalUrl},
      );

      final extractedData = response.data;
      final downloadUrl = extractedData['downloadUrl'];
      final title = extractedData['title'];

      // Update UI with real title
      _updateItemTitle(itemId, title);

      // 4. Determine where to temporarily save the file
      final tempDir = await getTemporaryDirectory();
      // Clean up the title to make a safe file name
      final safeTitle = title.toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').substring(0, 10);
      final savePath = '${tempDir.path}/${safeTitle}_$itemId.mp4';

      // 5. Download the actual Video File!
      await _dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Update the progress bar in real-time
            _updateItemProgress(itemId, received / total);
          }
        },
      );

      // 6. Save to the Phone's Gallery
      await Gal.putVideo(savePath);
      
      // Delete the temp file to save phone storage
      File(savePath).deleteSync();

      // UI update: Done!
      _updateItemTitle(itemId, '✅ Saved to Gallery: $title');

    } catch (e) {
      print("Download Error: $e");
      _updateItemTitle(itemId, '❌ Failed to download');
      _updateItemProgress(itemId, 0.0);
    }
  }

  // --- Helper Methods to update specific items in the list ---

  void _updateItemProgress(String id, double progress) {
    final index = _activeDownloads.indexWhere((item) => item.id == id);
    if (index != -1) {
      _activeDownloads[index].progress = progress;
      notifyListeners();
    }
  }

  void _updateItemTitle(String id, String newTitle) {
    final index = _activeDownloads.indexWhere((item) => item.id == id);
    if (index != -1) {
      _activeDownloads[index] = DownloadItem(
        id: _activeDownloads[index].id,
        title: newTitle,
        format: _activeDownloads[index].format,
        resolution: _activeDownloads[index].resolution,
        fileSize: _activeDownloads[index].fileSize,
        thumbnail: _activeDownloads[index].thumbnail,
        progress: _activeDownloads[index].progress,
      );
      notifyListeners();
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Request all possible Android storage/media permissions
      final storage = await Permission.storage.request();
      final videos = await Permission.videos.request();
      final photos = await Permission.photos.request();

      // If ANY of them are granted, we are good to go!
      if (storage.isGranted || videos.isGranted || photos.isGranted) {
        return true;
      }
      return false;
    } else if (Platform.isIOS) {
      final photosAdd = await Permission.photosAddOnly.request();
      final photos = await Permission.photos.request();
      if (photosAdd.isGranted || photos.isGranted) {
        return true;
      }
    }
    return false;
  }
}