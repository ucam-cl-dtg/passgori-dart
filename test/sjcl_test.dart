import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:nigori/nigori.dart';
import 'package:PassgoriExtension/sjcl.dart';
import 'package:nigori/test.dart';
import 'dart:scalarlist';

void main() {
  useHtmlConfiguration();
  Sjcl sjcl = new Sjcl();
  test('pbkdf2 of password,salt', () => expect(sjcl.pbkdf2(toBytes("password"), toBytes("salt"), 1000, 16),
      byteArrayEquals(toByteArray([110, -120, -66, -117, -83, 126, -82, -99, -98, 16, -86, 6, 18, 36, 3, 79]))));
  test('pbkdf2 of test, test', () => expect(sjcl.pbkdf2(toBytes("test"), toBytes("test"), 1000, 16),
      byteArrayEquals(toByteArray([120, 95, 112, -100, 17, 50, -77, 67, -77, 47, -101, -26, 71, -13, -121, 24]))));
  test('pbkdf2 of a,a', () => expect(sjcl.pbkdf2(toBytes("a"), toBytes("a"), 1000, 16),
      byteArrayEquals(toByteArray([127, -101, -127, -29, 64, -37, 95, -43, 19, -16, -70, 23, -47, -10, 113, -66]))));
  ByteArray key1 = sjcl.pbkdf2(toBytes("password"), toBytes("salt"), 1000, 16);
  byteArrayToString(sjcl.hmac(toBytes("plaintext"), key1));
  ByteArray key2 = sjcl.pbkdf2(toBytes("password1"), toBytes("salt"), 1000, 16);
  test('pbkdf2 of different passwords different', () => expect(key1,isNot(byteArrayEquals(key2))));
}