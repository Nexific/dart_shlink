extension ShlinkDateTime on DateTime {
  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? '-' : '';
    if (absN >= 1000) return '$n';
    if (absN >= 100) return '${sign}0$absN';
    if (absN >= 10) return '${sign}00$absN';
    return '${sign}000$absN';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '${n}';
    return '0${n}';
  }

  String toIso8601StringShlink() {
    String y = _fourDigits(year);
    String m = _twoDigits(month);
    String d = _twoDigits(day);
    String h = _twoDigits(hour);
    String min = _twoDigits(minute);
    String sec = _twoDigits(second);
    String tz_vz = timeZoneOffset.isNegative ? '-' : '+';
    String tz_h = _twoDigits(timeZoneOffset.inHours);
    String tz_min = '00';

    return '$y-$m-${d}T$h:$min:$sec$tz_vz$tz_h:$tz_min';
  }
}
