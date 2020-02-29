class Health {
  final String status;
  final String version;

  Health._(this.status, this.version);

  factory Health.fromJson(Map<String, dynamic> mJson) {
    return Health._(mJson['status'], mJson['version']);
  }

  @override
  String toString() => 'Health{status=$status;version=$version}';
}
