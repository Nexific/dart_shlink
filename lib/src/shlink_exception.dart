class ShlinkException implements Exception {
  final String type;
  final String title;
  final String detail;
  final int status;

  ShlinkException(this.type, this.title, this.detail, this.status);

  factory ShlinkException.fromJson(Map mJson) {
    return ShlinkException(mJson['type'], mJson['title'], mJson['detail'], mJson['status']);
  }

  @override
  String toString() => 'ShlinkException{type=$type;title=$title;detail=$detail;status=$status}';
}
