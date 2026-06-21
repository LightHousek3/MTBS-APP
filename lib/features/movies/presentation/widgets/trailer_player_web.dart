import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class TrailerPlayer extends StatefulWidget {
  const TrailerPlayer({required this.url, required this.uri, super.key});

  final String url;
  final Uri uri;

  @override
  State<TrailerPlayer> createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'mtbs-trailer-${DateTime.now().microsecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (_) {
      final iframe = web.HTMLIFrameElement()
        ..src = _embedUrl(widget.uri).toString()
        ..allow =
            'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
        ..allowFullscreen = true;
      iframe.style
        ..border = '0'
        ..height = '100%'
        ..width = '100%';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}

Uri _embedUrl(Uri uri) {
  final host = uri.host.toLowerCase();
  if (host.contains('youtube.com')) {
    final videoId = uri.queryParameters['v'];
    if (videoId != null && videoId.isNotEmpty) {
      return Uri.https('www.youtube.com', '/embed/$videoId', <String, String>{
        'autoplay': '1',
      });
    }
  }

  if (host == 'youtu.be') {
    final videoId = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    if (videoId != null && videoId.isNotEmpty) {
      return Uri.https('www.youtube.com', '/embed/$videoId', <String, String>{
        'autoplay': '1',
      });
    }
  }

  return uri;
}
