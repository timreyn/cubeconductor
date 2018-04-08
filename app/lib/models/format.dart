class Format {
  static Map<String, Format> _cache = new Map<String, Format>();

  factory Format(String formatCode) {
    if (_cache.containsKey(formatCode)) {
      return _cache[formatCode];
    } else {
      Format format = Format._internal(formatCode: formatCode);
      _cache[formatCode] = format;
      return format;
    }
  }

  Format._internal({this.formatCode});

  final String formatCode;
}