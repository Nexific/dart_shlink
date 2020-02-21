import 'package:shlink/shlink.dart';

void main() async {
  Shlink shlink = Shlink('https://example.com', 'my-api-key');

  ShortUrl short = await shlink.create(CreateShortURL.simple('https://github.com/Nexific/dart_shlink'));
  print(short);
}
