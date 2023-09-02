class WebviewArguments {
  String? title;
  String url;
  WebviewArguments({required this.url, this.title});

  @override
  String toString() {
    return '{url: $url, title: $title}';
  }
}
