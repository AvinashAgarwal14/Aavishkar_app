import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebRender extends StatelessWidget {

  WebRender({ Key key, this.link }) : super(key: key);

  String link;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: link,
        withZoom: true,
    );
  }
}
