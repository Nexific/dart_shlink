import 'dart:convert';

class ShlinkException implements Exception {
  final String type;
  final String title;
  final String detail;
  final int status;

  final int httpStatus;
  final String httpBody;

  ShlinkException(this.httpStatus, this.httpBody, this.type, this.title,
      this.detail, this.status);

  factory ShlinkException.fromJson(int iStatus, String sBody) {
    Map<String, dynamic> mJson = {};
    try {
      mJson = jsonDecode(sBody);
    } catch (_) {
      // ignored
    }

    return ShlinkException(iStatus, sBody, mJson['type'], mJson['title'],
        mJson['detail'], mJson['status']);
  }

  @override
  String toString() =>
      'ShlinkException{httpStatus=$httpStatus;type=$type;title=$title;detail=$detail;status=$status;body=$httpBody}';
}
