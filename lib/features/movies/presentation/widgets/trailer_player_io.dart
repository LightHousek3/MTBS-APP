import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrailerPlayer extends StatefulWidget {
  const TrailerPlayer({required this.url, required this.uri, super.key});

  final String url;
  final Uri uri;

  @override
  State<TrailerPlayer> createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  WebViewController? _controller;
  var _progress = 0;

  @override
  void initState() {
    super.initState();
    if (_supportsWebView) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              if (mounted) setState(() => _progress = progress);
            },
          ),
        )
        ..loadRequest(widget.uri);
    }
  }

  bool get _supportsWebView {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return _TrailerFallback(url: widget.url);
    }

    return Stack(
      children: <Widget>[
        WebViewWidget(controller: controller),
        if (_progress < 100) LinearProgressIndicator(value: _progress / 100),
      ],
    );
  }
}

class _TrailerFallback extends StatelessWidget {
  const _TrailerFallback({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.play_disabled_outlined, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Trình phát trailer chưa hỗ trợ nền tảng này.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SelectableText(url, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
