import 'dart:convert';
import 'dart:io';

import 'dto/health.dart';
import 'shlink_exception.dart';
import 'dto/create_short_url.dart';
import 'dto/meta.dart';
import 'dto/short_url.dart';
import 'dto/visit.dart';
import 'enums/order_field.dart';
import 'extension/datetime.dart';

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

  /// Update the Tags of the [shortCode] with [lstTags]
  Future<List<String>> updateTags(
      String shortCode, List<String> lstTags) async {
    String sUrl = '$_url$_API_PATH/short-urls/$shortCode/tags';
    if (_domain != null && _domain.isNotEmpty) {
      sUrl += '?domain=$_domain';
    }

    Map<String, dynamic> mJson = {'tags': lstTags};

    HttpClientRequest request = await HttpClient().putUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey)
      ..write(jsonEncode(mJson));

    HttpClientResponse response = await request.close();
    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode == 200) {
      Map<String, dynamic> mResponse = jsonDecode(sBody);
      return (mResponse['tags'] as List<dynamic>)
          .map((t) => t.toString())
          .toList();
    }

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

  /// List Short URLs
  ///
  /// [searchTerm]: Search in Long URL or Short Code
  /// [tags]: Filter by Tags
  /// [orderBy]: Sort output
  /// [startDate]: Begin Date
  /// [endDate]: End Date
  Future<List<ShortUrl>> list(
      {String searchTerm,
      List<String> tags,
      OrderField orderBy,
      DateTime startDate,
      DateTime endDate}) async {
    return _list(1, searchTerm, tags, orderBy, startDate, endDate);
  }

  /// Internal List method
  Future<List<ShortUrl>> _list(int iPage, String searchTerm, List<String> tags,
      OrderField orderBy, DateTime startDate, DateTime endDate) async {
    String sUrl = '$_url$_API_PATH/short-urls?page=$iPage';

    // Search Term
    if (searchTerm != null && searchTerm.isNotEmpty) {
      sUrl += '&searchTerm=${Uri.encodeQueryComponent(searchTerm)}';
    }

    // Tags
    if (tags != null && tags.isNotEmpty) {
      for (String sTag in tags) {
        sUrl += '&tags[]=${Uri.encodeQueryComponent(sTag)}';
      }
    }

    // Order By
    if (orderBy != null) {
      sUrl += '&orderBy=${orderBy.toString().split('.').last}';
    }

    // Start Date
    if (startDate != null) {
      sUrl +=
          '&startDate=${Uri.encodeQueryComponent(startDate.toIso8601StringShlink())}';
    }

    // End Date
    if (endDate != null) {
      sUrl +=
          'endDate=${Uri.encodeQueryComponent(endDate.toIso8601StringShlink())}';
    }

    HttpClientRequest request = await HttpClient().getUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey);

    HttpClientResponse response = await request.close();
    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode != 200) {
      throw ShlinkException.fromJson(response.statusCode, sBody);
    }

    List<ShortUrl> lstShortUrls = <ShortUrl>[];

    Map<String, dynamic> mJson = jsonDecode(sBody);
    Map<String, dynamic> mShortUrls = mJson['shortUrls'];

    List<dynamic> lstData = mShortUrls['data'];
    lstShortUrls.addAll(lstData.map((u) => ShortUrl.fromJson(u)).toList());

    Map<String, dynamic> mPagination = mShortUrls['pagination'];
    if (mPagination['pagesCount'] > mPagination['currentPage']) {
      lstShortUrls.addAll(await _list(
          iPage + 1, searchTerm, tags, orderBy, startDate, endDate));
    }

    return lstShortUrls;
  }

  /// List all Tags
  Future<List<String>> listTags() async {
    String sUrl = '$_url$_API_PATH/tags';

    HttpClientRequest request = await HttpClient().getUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey);

    HttpClientResponse response = await request.close();
    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode != 200) {
      throw ShlinkException.fromJson(response.statusCode, sBody);
    }

    Map<String, dynamic> mJson = jsonDecode(sBody);

    return (mJson['tags']['data'] as List<dynamic>)
        .map((t) => t.toString())
        .toList();
  }

  /// Add new Tags from [lstTags]
  Future<List<String>> addTags(List<String> lstTags) async {
    String sUrl = '$_url$_API_PATH/tags';

    Map<String, dynamic> mJsonReq = {'tags': lstTags};

    HttpClientRequest request = await HttpClient().postUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey)
      ..write(jsonEncode(mJsonReq));

    HttpClientResponse response = await request.close();
    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode != 200) {
      throw ShlinkException.fromJson(response.statusCode, sBody);
    }

    Map<String, dynamic> mJsonResp = jsonDecode(sBody);

    return (mJsonResp['tags']['data'] as List<dynamic>)
        .map((t) => t.toString())
        .toList();
  }

  /// Rename a tag from [oldName] to [newName]
  Future<bool> renameTag(String oldName, String newName) async {
    String sUrl = '$_url$_API_PATH/tags';

    Map<String, dynamic> mJson = {'oldName': oldName, 'newName': newName};

    HttpClientRequest request = await HttpClient().putUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey)
      ..write(jsonEncode(mJson));

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

  /// Delete the tags given in [lstTags]
  Future<bool> deleteTags(List<String> lstTags) async {
    String sUrl = '$_url$_API_PATH/tags';

    if (lstTags == null && lstTags.isEmpty) {
      return false;
    }

    bool bFirst = true;
    for (String sTag in lstTags) {
      if (bFirst) {
        sUrl += '?';
        bFirst = false;
      } else {
        sUrl += '&';
      }

      sUrl += 'tags[]=${Uri.encodeQueryComponent(sTag)}';
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

  /// List the visits of [shortCode] within [startDate] and [endDate]
  Future<List<Visit>> listVisits(String shortCode,
      {DateTime startDate, DateTime endDate}) async {
    return _listVisits(1, shortCode, startDate, endDate);
  }

  /// Internal visit list method
  Future<List<Visit>> _listVisits(
      int iPage, String shortCode, DateTime startDate, DateTime endDate) async {
    String sUrl = '$_url$_API_PATH/short-urls/${shortCode}/visits?page=$iPage';

    if (_domain != null && _domain.isNotEmpty) {
      sUrl += '&domain=$_domain';
    }

    // Start Date
    if (startDate != null) {
      sUrl +=
          '&startDate=${Uri.encodeQueryComponent(startDate.toIso8601StringShlink())}';
    }

    // End Date
    if (endDate != null) {
      sUrl +=
          '&endDate=${Uri.encodeQueryComponent(endDate.toIso8601StringShlink())}';
    }

    List<Visit> lstVisits = <Visit>[];

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

    Map<String, dynamic> mJson = jsonDecode(sBody);
    Map<String, dynamic> mVisits = mJson['visits'];

    List<dynamic> lstVisitsJson = mVisits['data'];
    lstVisits.addAll(lstVisitsJson.map((v) => Visit.fromJson(v)).toList());

    Map<String, dynamic> mPagination = mVisits['pagination'];
    if (mPagination['pagesCount'] > mPagination['currentPage']) {
      lstVisitsJson
          .addAll(await _listVisits(iPage + 1, shortCode, startDate, endDate));
    }

    return lstVisits;
  }

  /// Check the Health of the shlink Server
  Future<Health> checkHealth() async {
    String sUrl = '$_url$_API_PATH/health';
    
    HttpClientRequest request = await HttpClient().getUrl(Uri.parse(sUrl))
      ..headers.contentType = ContentType.json
      ..headers.set(_HEADER_API_KEY, _apiKey);

    HttpClientResponse response = await request.close();
    String sBody = await utf8.decoder.bind(response).single;

    if (response.statusCode != 200) {
      throw ShlinkException.fromJson(response.statusCode, sBody);
    }

    return Health.fromJson(jsonDecode(sBody));
  }
}
