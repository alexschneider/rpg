import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'package:http/browser_client.dart';

void main() {
  HttpRequest.request('https://lmu-diabolical.appspot.com/characters', method: 'GET', responseType: 'json')
  .then((HttpRequest res) {
    print(res.response);
  });
}
