import 'meta.dart';

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
    
    ShortUrlMeta meta = ShortUrlMeta.fromJson(mMeta);

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
