class ShortUrl {
  final String shortCode;
  final String shortUrl;
  final String longUrl;
  final DateTime dateCreated;
  final int visitsCount;
  final List<String> tags;
  final ShortUrlMeta meta;

  ShortUrl._(this.shortCode, this.shortUrl, this.longUrl, this.dateCreated,
      this.visitsCount, this.tags, this.meta);

  factory ShortUrl.fromJson(Map mJson) {
    Map mMeta = mJson['meta'];
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

    ShortUrlMeta meta = ShortUrlMeta._(validSince, validUntil, maxVisits);

    List<dynamic> lstRawTags = mJson['tags'];
    List<String> lstTags = lstRawTags.map((t) => '$t').toList();

    return ShortUrl._(
        mJson['shortCode'],
        mJson['shortUrl'],
        mJson['longUrl'],
        DateTime.parse(mJson['dateCreated']),
        mJson['visitCount'],
        lstTags,
        meta);
  }

  @override
  String toString() =>
      'ShortUrl{code=$shortCode;shortUrl=$shortUrl;longUrl=$longUrl;created=$dateCreated;visits=$visitsCount;tags=$tags;meta=$meta}';
}

class ShortUrlMeta {
  final DateTime validSince;
  final DateTime validUntil;
  final int maxVisits;

  ShortUrlMeta._(this.validSince, this.validUntil, this.maxVisits);

  @override
  String toString() =>
      'ShortUrlMeta{validSince=$validSince;validUntil=$validUntil;maxVisits=$maxVisits}';
}
