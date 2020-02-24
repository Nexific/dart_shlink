import 'dart:convert';
import 'dart:io';

import 'shlink_exception.dart';
import 'dto/create_short_url.dart';
import 'dto/meta.dart';
import 'dto/short_url.dart';

class Shlink {
  static const _API_PATH = '/rest/v1';
  static const _HEADER_API_KEY = 'X-Api-Key';

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

    HttpClientRequest request =
        await HttpClient().postUrl(Uri.parse('$_url$_API_PATH/short-urls'))
          ..headers.contentType = ContentType.json
          ..headers.set(_HEADER_API_KEY, _apiKey)
          ..write(jsonEncode(mJson));

    HttpClientResponse response = await request.close();
    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode != 200) {
      throw ShlinkException.fromJson(response.statusCode, sBody);
    }

    return ShortUrl.fromJson(jsonDecode(sBody));
  }

  /// Lookup short url information about the [shortCode]
  Future<ShortUrl> lookup(String shortCode) async {
    String sUrl = '$_url$_API_PATH/short-urls/$shortCode';
    if (_domain != null && _domain.isNotEmpty) {
      sUrl += '?domain=$_domain';
    }

    HttpClientRequest request = await HttpClient().getUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey);

    HttpClientResponse response = await request.close();
    if (response.statusCode == 404) {
      return null;
    }

    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode != 200) {
      throw ShlinkException.fromJson(response.statusCode, sBody);
    }

    return ShortUrl.fromJson(jsonDecode(sBody));
  }

  /// Update Metadata [meta] of [shortCode]
  Future<bool> updateMeta(String shortCode, ShortUrlMeta meta) async {
    String sUrl = '$_url$_API_PATH/short-urls/$shortCode';
    if (_domain != null && _domain.isNotEmpty) {
      sUrl += '?domain=$_domain';
    }

    HttpClientRequest request = await HttpClient().patchUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey)
      ..write(jsonEncode(meta.toJson()));

    HttpClientResponse response = await request.close();
    if (response.statusCode == 204) {
      return true;
    }

    if (response.statusCode == 404) {
      return false;
    }

    String sBody = await utf8.decoder.bind(response).single;
    throw ShlinkException.fromJson(response.statusCode, sBody);
  }

  /// Delete [shortCode]
  Future<bool> delete(String shortCode) async {
    String sUrl = '$_url$_API_PATH/short-urls/$shortCode';
    if (_domain != null && _domain.isNotEmpty) {
      sUrl += '?domain=$_domain';
    }

    HttpClientRequest request = await HttpClient().deleteUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey);

    HttpClientResponse response = await request.close();
    if (response.statusCode == 204) {
      return true;
    }

    if (response.statusCode == 404) {
      return false;
    }

    String sBody = await utf8.decoder.bind(response).single;
    throw ShlinkException.fromJson(response.statusCode, sBody);
  }
}
