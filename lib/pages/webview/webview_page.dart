import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:iwut_flutter/config/log/log.dart';
import 'package:iwut_flutter/widgets/iwut_scaffold.dart';
import 'package:iwut_flutter/widgets/loading_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final String? initUrl;
  final String? initData;
  final void Function(InAppWebViewController, String)? onLoadStop;
  final void Function(InAppWebViewController, String)? onLoadStart;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final String? title;
  final bool isShowTitle;
  final bool useShouldOverrideUrlLoading;

  WebViewPage({
    this.initUrl,
    this.initData,
    this.isShowTitle = true,
    this.useShouldOverrideUrlLoading = false,
    this.title,
    this.onLoadStop,
    this.onLoadStart,
    this.onWebViewCreated,
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _isLoading = ValueNotifier<bool>(true);
  bool _animationCompleted = false;

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    if (route != null && !_animationCompleted) {
      void handler(status) {
        if (status == AnimationStatus.completed) {
          route.animation!.removeStatusListener(handler);
          setState(() {
            _animationCompleted = true;
          });
        }
      }

      route.animation!.addStatusListener(handler);
    }
    return IwutScaffold(
      title: widget.title ?? widget.initUrl!,
      body: SafeArea(
        child: _animationCompleted
            ? ValueListenableBuilder(
                valueListenable: _isLoading,
                builder: (context, dynamic isLoadingValue, _) {
                  return Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: isLoadingValue ? 0 : 1,
                        child: InAppWebView(
                          initialData: widget.initData != null ? InAppWebViewInitialData(data: widget.initData!) : null,
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                              clearCache: true,
                              mediaPlaybackRequiresUserGesture: false,
                              useShouldOverrideUrlLoading: widget.useShouldOverrideUrlLoading,
                            ),
                            android: AndroidInAppWebViewOptions(
                              useHybridComposition: true,
                              mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                            ),
                            ios: IOSInAppWebViewOptions(
                              allowsInlineMediaPlayback: true,
                            ),
                          ),
                          androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                            return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                          },
                          initialUrlRequest: widget.initUrl != null ? URLRequest(url: Uri.parse(widget.initUrl!)) : null,
                          onWebViewCreated: (controller) {
                            widget.onWebViewCreated?.call(controller);
                          },
                          shouldOverrideUrlLoading: (controller, navigationAction) {
                            if (navigationAction.request.url.toString() == 'about:blank') {
                              return Future.value(NavigationActionPolicy.ALLOW);
                            }
                            launch(navigationAction.request.url.toString());
                            return Future.value(NavigationActionPolicy.CANCEL);
                          },
                          onLoadStart: (controller, url) {
                            widget.onLoadStart?.call(controller, url.toString());
                          },
                          onLoadStop: (controller, url) {
                            Log.debug('webView ==> ${url.toString()}', tag: 'WebView');
                            if (isLoadingValue) _isLoading.value = false;
                            widget.onLoadStop?.call(controller, url.toString());
                          },
                          onLoadError: (controller, url, code, message) {
                            Log.error('onWebViewLoadError : ${url.toString()}, message : $message', tag: 'WebView');
                            controller.loadFile(assetFilePath: "assets/html/404.html");
                          },
                          onLoadHttpError: (controller, url, code, message) {
                            Log.error('onWebViewLoadHttpError : ${url.toString()}', tag: 'WebView');
                            controller.loadFile(assetFilePath: "assets/html/404.html");
                          },
                        ),
                      ),
                      isLoadingValue ? LoadingDialog() : Container()
                    ],
                  );
                },
              )
            : Container(),
      ),
    );
  }
}
