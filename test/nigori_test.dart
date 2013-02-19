import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:PassgoriExtension/nigori.dart';
import 'package:PassgoriExtension/keys.dart';

void main() {
  useHtmlConfiguration();
  
  String server_name = "localhost:8080";//"nigori-dev.appspot.com";
  NigoriKeys keys = new NigoriKeys.derive("test","test",server_name);
  NigoriHttpJsonClient client = new NigoriHttpJsonClient(keys,server_name);
  test('register', () => client.register());
  test('authenticate', () => client.authenticate());
}