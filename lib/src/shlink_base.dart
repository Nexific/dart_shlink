import 'dart:convert';
import 'dart:io';

import 'shlink_exception.dart';
import 'dto/create_short_url.dart';
import 'dto/short_url.dart';

class Shlink {
  final String _url;
  final String _apiKey;
  final String _domain;

  /// Create a shlink.io Client using the Base URL [_url] with the API-Key [_apiKey] and the Short URL Domain [_domain]
  Shlink(this._url, this._apiKey, [this._domain]);

  /// Create a new [shortURL]
  Future<ShortUrl> create(CreateShortURL shortURL) async {
    Map<String, dynamic> mJson = shortURL.toJson();

    if (_domain != null && _domain.isNotEmpty) {
      mJson.putIfAbsent('domain', () => _domain);
    }

    HttpClientRequest request = await HttpClient().postUrl(Uri.parse('$_url/rest/v1/short-urls'))
      ..headers.contentType = ContentType.json
      ..headers.set('X-Api-Key', _apiKey)
      ..write(jsonEncode(mJson));

    HttpClientResponse response = await request.close();
    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode != 200) {
      throw ShlinkException.fromJson(jsonDecode(sBody));
    }

    return ShortUrl.fromJson(jsonDecode(sBody));
  }
}
