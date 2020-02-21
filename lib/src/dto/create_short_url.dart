class CreateShortURL {
  final String _longUrl;
  final List<String> _tags;
  final DateTime _validSince;
  final DateTime _validUntil;
  final String _customSlug;
  final int _maxVisits;
  final bool _findIfExists;

  CreateShortURL._(this._longUrl, this._tags, this._validSince,
      this._validUntil, this._customSlug, this._maxVisits, this._findIfExists);

  /// Create a new short URL from [longUrl] with [tags] valid from [validSince] until [validUntil] with [customSlug] until [maxVisits] and [findIfExists]
  factory CreateShortURL(String longUrl,
      {List<String> tags,
      DateTime validSince,
      DateTime validUntil,
      String customSlug,
      int maxVisits = 0,
      bool findIfExists = false}) {
    return CreateShortURL._(longUrl, tags, validSince, validUntil, customSlug,
        maxVisits, findIfExists);
  }

  /// Create a new short URL from [longUrl]
  factory CreateShortURL.simple(String longUrl) {
    return CreateShortURL._(longUrl, null, null, null, null, 0, false);
  }

  /// Create a new short URL from [longUrl] with [customSlug]
  factory CreateShortURL.custom(String longUrl, String customSlug) {
    return CreateShortURL._(longUrl, null, null, null, customSlug, 0, false);
  }

  /// Create a new short URL from [longURL] expirering on [validUntil]
  factory CreateShortURL.expirering(String longUrl, DateTime validUntil) {
    return CreateShortURL._(longUrl, null, null, validUntil, null, 0, false);
  }

  /// Create a JSON Map from this object
  Map<String, dynamic> toJson() {
    Map<String, dynamic> mJson = {
      'longUrl': _longUrl,
      'findIfExists': _findIfExists
    };

    if (_tags != null && _tags.isNotEmpty) {
      mJson.putIfAbsent('tags', () => _tags);
    }

    if (_validSince != null) {
      mJson.putIfAbsent('validSince', () => _validSince.toIso8601String());
    }

    if (_validUntil != null) {
      mJson.putIfAbsent('validUntil', () => _validUntil.toIso8601String());
    }

    if (_customSlug != null && _customSlug.isNotEmpty) {
      mJson.putIfAbsent('customSlug', () => _customSlug);
    }

    if (_maxVisits > 0) {
      mJson.putIfAbsent('maxVisits', () => _maxVisits);
    }

    return mJson;
  }
}
