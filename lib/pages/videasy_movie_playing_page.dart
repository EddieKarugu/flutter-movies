import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Only import dart:html for web – it's safe and works
import 'dart:html' as html;

class VideasyMoviePlayerPage extends StatefulWidget {
  final int movieId;
  final String movieTitle;
  final String? colorHex;
  final int? startSeconds;

  const VideasyMoviePlayerPage({
    super.key,
    required this.movieId,
    required this.movieTitle,
    this.colorHex,
    this.startSeconds,
  });

  @override
  State<VideasyMoviePlayerPage> createState() => _VideasyMoviePlayerPageState();
}

class _VideasyMoviePlayerPageState extends State<VideasyMoviePlayerPage> {
  String get _videoUrl {
    String url = 'https://player.videasy.net/movie/${widget.movieId}';
    final params = <String, String>{};
    if (widget.colorHex != null) params['color'] = widget.colorHex!;
    if (widget.startSeconds != null) params['progress'] = widget.startSeconds.toString();
    if (params.isNotEmpty) {
      url += '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieTitle),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: kIsWeb
          ? const _WebPlayer()  // No need to pass URL here – we'll set it later
          : _MobilePlayer(videoUrl: _videoUrl),
    );
  }
}

// ------------------------------------------------------------------
// Web Player: Uses dart:html + custom element with data-src
// ------------------------------------------------------------------
class _WebPlayer extends StatefulWidget {
  const _WebPlayer();

  @override
  State<_WebPlayer> createState() => _WebPlayerState();
}

class _WebPlayerState extends State<_WebPlayer> {
  String? _videoUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final page = context.findAncestorStateOfType<_VideasyMoviePlayerPageState>();
    final newUrl = page?._videoUrl;
    if (_videoUrl != newUrl) {
      _videoUrl = newUrl;
      if (_videoUrl != null) {
        // Wait for the next frame so the element exists
        WidgetsBinding.instance.addPostFrameCallback((_) => _setDataSource());
      }
    }
  }

  void _setDataSource() {
    if (_videoUrl == null) return;
    // Try to find the element; if not yet present, retry once after a short delay
    final elements = html.document.querySelectorAll('div-placeholder');
    if (elements.isEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _setDataSource(); // retry
      });
      return;
    }
    final element = elements.last;
    final currentSrc = element.getAttribute('data-src');
    if (currentSrc != _videoUrl) {
      element.setAttribute('data-src', _videoUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: 'div-placeholder');
  }
}

// ------------------------------------------------------------------
// Mobile Player: Uses InAppWebView (Android & iOS)
// ------------------------------------------------------------------
class _MobilePlayer extends StatelessWidget {
  final String videoUrl;
  const _MobilePlayer({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(videoUrl)),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
        android: AndroidInAppWebViewOptions(useHybridComposition: true),
        ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
      ),
    );
  }
}