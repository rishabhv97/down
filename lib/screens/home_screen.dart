import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/download_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _urlController = TextEditingController();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildInputSection(context),
            const SizedBox(height: 32),

            // --- Popular Platforms ---
            const Text(
              'Popular Platforms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildPopularPlatforms(),

            const SizedBox(height: 32),

            // --- Quick Tools ---
            const Text(
              'Quick Tools',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickTools(),

            const SizedBox(height: 32),

            // --- Active Downloads ---
            _buildActiveDownloads(),
          ],
        ),
      ),
    );
  }

  // --- HEADER WIDGET ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.downloading, color: Color(0xFF7C3AED), size: 28),
            SizedBox(width: 8),
            Text(
              'Downloader',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.settings_outlined, color: Colors.grey, size: 26),
          ],
        ),
      ],
    );
  }

  // --- INPUT SECTION WIDGET ---
  Widget _buildInputSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E212B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.link, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _urlController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Paste link here...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {
                final url = _urlController.text.trim();
                print("--- DEBUG: Button Pressed! ---");
                print("--- DEBUG: URL is: '$url' ---");

                if (url.isNotEmpty) {
                  context.read<DownloadProvider>().startNewDownload(url);
                  _urlController.clear();
                } else {
                  print("--- DEBUG: The URL was empty! ---");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Download',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- POPULAR PLATFORMS WIDGET ---
  Widget _buildPopularPlatforms() {
    final platforms = [
      {'asset': 'assets/icons/youtube.png', 'name': 'YouTube'},
      {'asset': 'assets/icons/instagram.png', 'name': 'Instagram'},
      {'asset': 'assets/icons/facebook.png', 'name': 'Facebook'},
      {'asset': 'assets/icons/twitter.png', 'name': 'X (Twitter)'},
      {'asset': 'assets/icons/tiktok.png', 'name': 'TikTok'},
      {'asset': 'assets/icons/reddit.png', 'name': 'Reddit'},
      {'asset': 'assets/icons/pinterest.png', 'name': 'Pinterest'},
      {'asset': 'assets/icons/twitch.png', 'name': 'Twitch'},
      {'asset': 'assets/icons/threads.png', 'name': 'Threads'},
      {'isMore': true, 'name': 'More'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: platforms.length,
      itemBuilder: (context, index) {
        final platform = platforms[index];

        if (platform.containsKey('isMore')) {
          return Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E212B),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'More',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          );
        }

        return Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  platform['asset'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              platform['name'] as String,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  // --- QUICK TOOLS WIDGET ---
  Widget _buildQuickTools() {
    final tools = [
      {
        'title': 'Batch Download',
        'desc': 'Multiple files',
        'icon': Icons.library_add_check,
        'color': Colors.orange,
      },
      {
        'title': 'Extract Audio',
        'desc': 'MP4 to MP3',
        'icon': Icons.audiotrack,
        'color': Colors.purple,
      },
      {
        'title': 'Private Video',
        'desc': 'Requires login',
        'icon': Icons.lock,
        'color': Colors.teal,
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tools.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final tool = tools[index];
          return Container(
            width: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E212B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (tool['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    tool['icon'] as IconData,
                    color: tool['color'] as Color,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Text(
                  tool['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tool['desc'] as String,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- ACTIVE DOWNLOADS WIDGET ---
  Widget _buildActiveDownloads() {
    return Consumer<DownloadProvider>(
      builder: (context, provider, child) {
        if (provider.activeDownloads.isEmpty) {
          return const SizedBox.shrink(); // Show nothing if no downloads
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Downloads',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...provider.activeDownloads.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E212B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(item.progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Color(0xFF7C3AED),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // The actual progress bar
                    LinearProgressIndicator(
                      value: item.progress,
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                      color: const Color(0xFF7C3AED),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
