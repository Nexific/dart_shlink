import '../extension/datetime.dart';

class ShortUrlMeta {
  final DateTime validSince;
  final DateTime validUntil;
  final int maxVisits;

  ShortUrlMeta._(this.validSince, this.validUntil, this.maxVisits);

  factory ShortUrlMeta.validSince(DateTime validSince) {
    return ShortUrlMeta._(validSince, null, null);
  }

  factory ShortUrlMeta.validUntil(DateTime validUntil) {
    return ShortUrlMeta._(null, validUntil, null);
  }

  factory ShortUrlMeta.valid(DateTime validSince, DateTime validUntil) {
    return ShortUrlMeta._(validSince, validUntil, null);
  }

  factory ShortUrlMeta.visits(int maxVisits) {
    return ShortUrlMeta._(null, null, maxVisits);
  }

  factory ShortUrlMeta.all(
      {DateTime validSince, DateTime validUntil, int maxVisits}) {
    return ShortUrlMeta._(validSince, validUntil, maxVisits);
  }

  factory ShortUrlMeta.fromJson(Map mMeta) {
    DateTime validSince;
    DateTime validUntil;
    int maxVisits = 0;

    if (mMeta.containsKey('validSince') && mMeta['validSince'] != null) {
      validSince = DateTime.parse(mMeta['validSince']);
    }

    if (mMeta.containsKey('validUntil') && mMeta['validUntil'] != null) {
      validUntil = DateTime.parse(mMeta['validUntil']);
    }

    if (mMeta.containsKey('maxVisits') && mMeta['maxVisits'] != null) {
      maxVisits = mMeta['maxVisits'];
    }

    return ShortUrlMeta._(validSince, validUntil, maxVisits);
  }

  Map<String, dynamic> toJson() {
    return {
      'validSince': validSince?.toIso8601StringShlink(),
      'validUntil': validUntil?.toIso8601StringShlink(),
      'maxVisits': maxVisits
    };
  }

  @override
  String toString() =>
      'ShortUrlMeta{validSince=$validSince;validUntil=$validUntil;maxVisits=$maxVisits}';
}
