A library to access [shlink.io](https://shlink.io) based URL shortener.

[![Build Status](https://travis-ci.org/Nexific/dart_shlink.svg?branch=master)](https://travis-ci.org/Nexific/dart_shlink)

## Usage

Add the following dependency to the pubspec.yaml

**Stable**

```yaml
dependencies:
  shlink: ^0.5.0
```

**Development**

```yaml
dependencies:
  shlink: ^0.6.0
```

NOTE: This version is not yet available on pub.dev

**How to use this lib:**

```dart
import 'package:shlink/shlink.dart';

void main() async {
  Shlink shlink = Shlink('https://example.com', 'my-api-key');

  ShortUrl short = await shlink.create(CreateShortURL.simple('https://github.com/Nexific/dart_shlink'));
  print(short);
}
```
