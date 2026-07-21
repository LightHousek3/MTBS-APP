import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mtbs_app/core/widgets/app_hash_loader.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeBannerVideoPlayer extends StatelessWidget {
  const HomeBannerVideoPlayer({
    required this.url,
    required this.onCompleted,
    super.key,
  });

  final String url;
  final VoidCallback onCompleted;

  bool get _useWebView =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    return _useWebView
        ? _AndroidBannerVideoPlayer(url: url, onCompleted: onCompleted)
        : _NativeBannerVideoPlayer(url: url, onCompleted: onCompleted);
  }
}

class _AndroidBannerVideoPlayer extends StatefulWidget {
  const _AndroidBannerVideoPlayer({
    required this.url,
    required this.onCompleted,
  });

  final String url;
  final VoidCallback onCompleted;

  @override
  State<_AndroidBannerVideoPlayer> createState() =>
      _AndroidBannerVideoPlayerState();
}

class _AndroidBannerVideoPlayerState extends State<_AndroidBannerVideoPlayer> {
  WebViewController? _controller;
  bool _pageLoaded = false;
  Object? _error;
  int _sessionId = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant _AndroidBannerVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    final sessionId = ++_sessionId;
    _error = null;
    _pageLoaded = false;

    if (mounted) {
      setState(() {});
    }

    try {
      final controller = WebViewController();
      _controller = controller;

      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted || sessionId != _sessionId) return;
            _pageLoaded = true;
            setState(() {});
            unawaited(
              controller.runJavaScript(
                'window.startBannerVideo && window.startBannerVideo();',
              ),
            );
          },
          onWebResourceError: (error) {
            if (!mounted || sessionId != _sessionId) return;
            _error = error;
            setState(() {});
          },
        ),
      );
      await controller.addJavaScriptChannel(
        'BannerVideo',
        onMessageReceived: (message) {
          if (!mounted || sessionId != _sessionId) return;

          switch (message.message) {
            case 'ended':
              widget.onCompleted();
              break;
            case 'error':
            case 'play_error':
              _error = StateError('Banner video playback failed');
              setState(() {});
              break;
          }
        },
      );
      await controller.loadHtmlString(_buildHtml(widget.url));
    } catch (error) {
      if (sessionId != _sessionId) return;
      _error = error;
      if (mounted) setState(() {});
    }
  }

  void _retry() {
    unawaited(_initialize());
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_pageLoaded) {
      return _error == null
          ? const ColoredBox(
              color: Color(0xFF111318),
              child: Center(child: AppHashLoader(size: 32)),
            )
          : _VideoErrorSurface(onRetry: _retry);
    }

    if (_error != null) {
      return _VideoErrorSurface(onRetry: _retry);
    }

    return ClipRect(child: WebViewWidget(controller: _controller!));
  }
}

class _NativeBannerVideoPlayer extends StatefulWidget {
  const _NativeBannerVideoPlayer({
    required this.url,
    required this.onCompleted,
  });

  final String url;
  final VoidCallback onCompleted;

  @override
  State<_NativeBannerVideoPlayer> createState() =>
      _NativeBannerVideoPlayerState();
}

class _NativeBannerVideoPlayerState extends State<_NativeBannerVideoPlayer> {
  VideoPlayerController? _controller;
  Timer? _completionPoller;
  Object? _error;
  bool _completed = false;
  int _sessionId = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant _NativeBannerVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _initialize();
    }
  }

  @override
  void dispose() {
    _resetControllerState();
    super.dispose();
  }

  Future<void> _initialize() async {
    final sessionId = ++_sessionId;
    _resetControllerState();
    _error = null;
    _completed = false;
    if (mounted) {
      setState(() {});
    }

    final uri = Uri.tryParse(widget.url);
    if (uri == null || !uri.hasScheme) {
      _error = StateError('Invalid banner video URL');
      if (mounted) setState(() {});
      return;
    }

    final controller = VideoPlayerController.networkUrl(uri);
    _controller = controller;
    controller.addListener(_handleControllerUpdate);

    try {
      await controller.initialize();
      if (!mounted || sessionId != _sessionId || _controller != controller) {
        await controller.dispose();
        return;
      }
      await controller.setLooping(false);
      await controller.setVolume(0);
      if (mounted) setState(() {});
      await _play(sessionId);
    } catch (error) {
      if (sessionId != _sessionId) return;
      _error = error;
      if (mounted) setState(() {});
    }
  }

  void _resetControllerState() {
    _completionPoller?.cancel();
    _completionPoller = null;

    final controller = _controller;
    if (controller != null) {
      controller.removeListener(_handleControllerUpdate);
      controller.dispose();
    }
    _controller = null;
  }

  void _handleControllerUpdate() {
    final controller = _controller;
    if (controller == null || _completed) return;
    _checkCompletion(controller.value);
  }

  void _startCompletionPolling(int sessionId) {
    _completionPoller?.cancel();
    _completionPoller = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final controller = _controller;
      if (controller == null || _completed || sessionId != _sessionId) return;
      _checkCompletion(controller.value);
    });
  }

  void _checkCompletion(VideoPlayerValue value) {
    if (!value.isInitialized || _completed) return;

    final duration = value.duration;
    if (duration == Duration.zero) return;

    final position = value.position;
    if (value.isCompleted || position >= duration) {
      _completed = true;
      _completionPoller?.cancel();
      widget.onCompleted();
    }
  }

  Future<void> _play(int sessionId) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      _error = null;
      await controller.play();
      if (!mounted || sessionId != _sessionId) return;
      _startCompletionPolling(sessionId);
      setState(() {});
    } catch (error) {
      if (!mounted || sessionId != _sessionId) return;
      _completionPoller?.cancel();
      _error = error;
      setState(() {});
    }
  }

  void _retryPlayback() {
    unawaited(_play(_sessionId));
  }

  void _retryInitialize() {
    unawaited(_initialize());
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return ColoredBox(
        color: const Color(0xFF111318),
        child: Center(
          child: _error == null
              ? const AppHashLoader(size: 32)
              : _VideoErrorSurface(onRetry: _retryInitialize),
        ),
      );
    }

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
          if (_error != null)
            _VideoErrorSurface(
              onRetry: _retryPlayback,
              compact: true,
            ),
        ],
      ),
    );
  }
}

class _VideoErrorSurface extends StatelessWidget {
  const _VideoErrorSurface({required this.onRetry, this.compact = false});

  final VoidCallback onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final button = IconButton.filled(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh_rounded),
      iconSize: compact ? 24 : 40,
      color: Colors.white,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.55),
        fixedSize: compact ? const Size.square(56) : const Size.square(72),
      ),
    );

    return Center(child: button);
  }
}

String _buildHtml(String url) {
  final source = jsonEncode(url);

  return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      overflow: hidden;
      background: #111318;
    }
    body {
      display: flex;
      align-items: stretch;
      justify-content: stretch;
    }
    video {
      width: 100%;
      height: 100%;
      object-fit: cover;
      background: #111318;
    }
  </style>
</head>
<body>
  <video
    id="bannerVideo"
    autoplay
    muted
    playsinline
    webkit-playsinline
    preload="auto">
  </video>
  <script>
    const video = document.getElementById('bannerVideo');
    const sourceUrl = $source;
    const notify = (message) => {
      if (window.BannerVideo && window.BannerVideo.postMessage) {
        window.BannerVideo.postMessage(message);
      }
    };

    video.src = sourceUrl;
    video.addEventListener('ended', () => notify('ended'));
    video.addEventListener('error', () => notify('error'));

    window.startBannerVideo = function () {
      const playPromise = video.play();
      if (playPromise && typeof playPromise.catch === 'function') {
        playPromise.catch(() => notify('play_error'));
      }
    };

    video.addEventListener('loadedmetadata', window.startBannerVideo);
    window.startBannerVideo();
  </script>
</body>
</html>
''';
}
