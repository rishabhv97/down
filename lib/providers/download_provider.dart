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
  
  // URL for your new local Node.js backend
  // Use 10.0.2.2 for Android Emulator, or your computer's local IP (e.g., 192.168.x.x) for physical devices
  final String _backendUrl = 'http://192.168.0.121:3000';

  List<DownloadItem> get activeDownloads => _activeDownloads;

  // NEW METHOD: Fetch video info without downloading
  Future<Map<String, dynamic>?> getVideoInfo(String url) async {
    try {
      final response = await _dio.post(
        '$_backendUrl/info',
        data: {'url': url},
      );
      return response.data; // Returns { title, thumbnail, duration, formats: [...] }
    } catch (e) {
      print("Failed to fetch info: $e");
      return null;
    }
  }

  // Updated method signature to accept optional formatId and qualityName
  Future<void> startNewDownload(String originalUrl, {String? formatId, String qualityName = 'Best'}) async {
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
      title: 'Processing on server...', 
      format: 'MP4',
      resolution: qualityName, // Uses the quality chosen from the Bottom Sheet
      fileSize: '...',
      thumbnail: '',
      progress: 0.0,
    );
    
    _activeDownloads.insert(0, newItem);
    notifyListeners();

    try {
      print("--- DEBUG: Asking custom backend to download via yt-dlp... ---");
      
      // 3. Ask your Node.js backend to download and merge the video
      final serverResponse = await _dio.post(
        '$_backendUrl/download',
        data: {
          'url': originalUrl,
          if (formatId != null) 'format_id': formatId // Sends the specific quality ID to the backend
        },
        options: Options(receiveTimeout: const Duration(minutes: 10)), 
      );

      if (serverResponse.statusCode == 200 && serverResponse.data['success'] == true) {
        
        final String fileUrlFromBackend = serverResponse.data['fileUrl'];
        // Convert localhost to 10.0.2.2 so the Android emulator can find the file
        final String actualDownloadUrl = fileUrlFromBackend.replaceAll('localhost', '192.168.0.121');
        
        _updateItemTitle(itemId, 'Transferring to phone...');

        // 4. Determine where to temporarily save the file
        final tempDir = await getTemporaryDirectory();
        final savePath = '${tempDir.path}/video_$itemId.mp4';

        // 5. Download from your Node.js server to the Flutter app
        await _dio.download(
          actualDownloadUrl,
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
        _updateItemTitle(itemId, '✅ Saved to Gallery');
      } else {
        throw Exception("Backend failed to process video");
      }

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