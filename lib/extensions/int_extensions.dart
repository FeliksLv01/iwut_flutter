extension Util on int {
  String get length2Str => "${this < 10 ? '0$this' : '$this'}";
}
