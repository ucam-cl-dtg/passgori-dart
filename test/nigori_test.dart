import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:PassgoriExtension/nigori.dart';
import 'package:PassgoriExtension/keys.dart';
import 'package:nigori/nigori.dart';
import 'dart:scalarlist';

void main() {
  useHtmlConfiguration();
  
  String server_name = "localhost:8080";//"nigori-dev.appspot.com";
  NigoriKeys keys = new NigoriKeys.derive("test","test",server_name);
  NigoriHttpJsonClient client = new NigoriHttpJsonClient(keys,server_name);
  test('register', () => client.register()
      .then(expectAsync1((response) => expect(response,equals(true))))
      .catchError((error) => registerException(error)));
  test('authenticate', () => client.authenticate()
      .then(expectAsync1((response) => expect(response,equals(true))))
      .catchError((error) => registerException(error)));
  ByteArray index = toBytes("index");
  ByteArray revision = toBytes("revision");
  ByteArray value = toBytes("value");
  test('get-indices none', () => client.getIndices());
  test('put', () => client.put(index, revision, value));
  test('get', () => client.get(index,revision));
  test('get-indices one', () => client.getIndices());
  test('get-revisions', () => client.getRevisions(index));
  test('delete', () => client.delete(index));
  test('get-revisions deleted', () => client.getRevisions(index));
  test('unregister', () => client.unregister()
      .then(expectAsync1((response) => expect(response,equals(true))))
      .catchError((error) => registerException(error)));
}