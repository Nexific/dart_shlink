import 'package:shlink/shlink.dart';

class Visit {
  final String referer;
  final DateTime date;
  final String userAgent;
  final VisitLocation visitLocation;

  Visit._(this.referer, this.date, this.userAgent, this.visitLocation);

  factory Visit.fromJson(Map mJson) {
    String referer = mJson['referer'];
    DateTime date = DateTime.parse(mJson['date']);
    String userAgent = mJson['userAgent'];
    VisitLocation visitLocation;

    if (mJson.containsKey('visitLocation') && mJson['visitLocation'] != null) {
      visitLocation = VisitLocation.fromJson(mJson['visitLocation']);
    }

    return Visit._(referer, date, userAgent, visitLocation);
  }

  @override
  String toString() =>
      'Visit{referer=$referer;date=$date;userAgent=$userAgent;visitLocation=$visitLocation}';
}

class VisitLocation {
  final String cityName;
  final String countryCode;
  final String countryName;
  final String latitude;
  final String longitude;
  final String regionName;
  final String timezone;

  VisitLocation._(this.cityName, this.countryCode, this.countryName,
      this.latitude, this.longitude, this.regionName, this.timezone);

  factory VisitLocation.fromJson(Map mJson) {
    return VisitLocation._(
        mJson['cityName'],
        mJson['countryCode'],
        mJson['countryName'],
        mJson['latitude'],
        mJson['longitude'],
        mJson['regionName'],
        mJson['timezone']);
  }

  @override
  String toString() =>
      'VisitLocation{cityName=$cityName;countryCode=$countryCode;countryName=$countryName;latitude=$latitude;longitude=$longitude;regionName=$regionName;timezone=$timezone}';
}
