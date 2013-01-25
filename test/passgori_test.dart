import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:PassgoriExtension/keys.dart';
import 'package:PassgoriExtension/sjcl.dart';
import 'package:nigori/nigori.dart';
import 'package:nigori/test.dart';
import 'dart:scalarlist';

void main() {
  useHtmlConfiguration();

  test('constants salt not null', () => expect(NigoriConstants.Usersalt,isNotNull));
  test('keyderivation', () => new NigoriKeys.derive("test","test","test"));
  NigoriKeys keys = new NigoriKeys.derive("test","test","test");
  test('kUser not null', () => expect(keys.kUser,isNotNull));
  test('kEnc not null', () => expect(keys.kEnc,isNotNull));
  test('kMac not null', () => expect(keys.kMac,isNotNull));
  test('kIv not null', () => expect(keys.kIv,isNotNull));
  test('kUser expected value', () => expect(keys.kUser,
      byteArrayEquals(toByteArray([-90, 53, 48, 91, 43, 53, 5, 59, -14, -124, -16, -123, 112, -44, -111, 117, -34, -44, 10, -42, 63, -107, -91, -50, 101, -20, 124, -57, -106, 68, 26, 87, 105, -78, 37, -35, -103, 106, 104, 43, -33, -19, -103, -21, 50, 2, 125, -19, 24, 63, -23, 127, 18, -37, 43, -4, 86, 114, -104, 23, -128, 66, -83, 51, 61, -86, -11, 55, 33, 53, 38, 95, -68, 60, 94, -1, -49, -114, 67, 98, 5, 67, 34, 53, -14, 122, -76, -123, -75, -6, -80, 89, -70, 34, 81, -65, -103, 86, -3, 69, 80, -52, 38, 75, -3, 57, 14, 34, -14, 94, -54, 27, 47, 105, 43, 44, -77, -22, 113, 44, 97, -113, 9, 97, -36, 69, 70, 52, 102, 69, -119, 40, 53, 26, 63, 78, 44, 41, 30, -100, -112, -52, -11, -51, -34, -83, -105, -69, -29, 82, -76, 40, 119, 37, 80, 95, 83, 86, -113, -45, 115, 113, 56, -68, 44, -50, -84, -85, -46, 8, 43, -86, 104, 115, -99, 56, -23, -44, 61, -16, -113, -13, -19, -82, -106, 30, 23, -24, -76, -29, -83, -118, 93, 2, 40, -48, 69, 45, -126, -11, 8, 39, -87, 94, -87, 86, -18, 20, -79, -36, -84, -108, 33, 105, -11, -35, -110, -47, -122, -89, 102, -84, 126, 23, 66, -104, -115, -51, 38, 75, 61, -44, 39, -36, 117, 127, 0, -26, -68, -116, -25, 115, -90, -30, 30, 20, 102, 109, 1, -100, 0, -50, -125, 42, -113, 68, -53, -83, -76, -47, 1, 6, 83, -16, -34, 19, 50, 115, 73, 91, -20, -79, -85, -15, -6, -54, 3, 80, 22, -13, 82, 75, 66, -86, 117, -40, 68, 122, 21, 89, -28, -96, 127, 40, 122, -90, 75, 38, 79, -71, -52, 64, 59, -123, -105, -127, 116, -118, 92, 48, 52, 17, 29, -52, -40, 56, 44, -13, -54, 51, 43, 24, 84, -40, 104, 27, 25, -102, -106, 64, 11, -111, -83, 52, 47, -72, 102, 93, 74, 113, -90, -12, 21, 62, -126, -109, -81, 7, 56, -125, -21, 31, 91, -74, 103, 120, 76, 108, -121, 86, -9, -78, -103, -1, -102, -4, 1, -120, 80, 32, 45, 85, 117, -76, 42, 84, 70, 86, 63, 64, 52, -33, 3, 102]))));
  test('kEnc expected value', () => expect(keys.kEnc,
      byteArrayEquals(toByteArray([100, 127, -15, 75, 25, -80, 103, -102, 26, -69, 102, -100, 60, 33, -93, 101]))));
  test('kMac expected value', () => expect(keys.kMac,
      byteArrayEquals(toByteArray([-41, 123, -20, -61, 71, -114, 46, -85, 98, 101, 110, 50, 88, -26, 38, 77]))));
  test('kIv expected value', () => expect(keys.kIv,
      byteArrayEquals(toByteArray([24, -22, -98, 6, 15, -94, -72, -6, 44, -83, 44, 17, 81, 27, 71, -80]))));
  Sjcl sjcl = new Sjcl();
  ByteArray plaintext = toBytes("plaintext");
  /*
  test('encryption runs', () => sjcl.enc(keys.kEnc, keys.kMac, plaintext));
  test('encryption not identity', () => expect(sjcl.enc(keys.kEnc, keys.kMac, plaintext),isNot(byteArrayEquals(plaintext))));
  test('encryption of same value twice gives different answers', () =>
      expect(sjcl.enc(keys.kEnc, keys.kMac, plaintext),
          isNot(byteArrayEquals(sjcl.enc(keys.kEnc, keys.kMac, plaintext)))));
  test('deterministic encryption of same value twice gives the same answer', () =>
      expect(sjcl.encDet(keys.kEnc, keys.kMac, keys.kIv, plaintext),
          byteArrayEquals(sjcl.encDet(keys.kEnc, keys.kMac, keys.kIv, plaintext))));
  */
  test('deterministic encryption returns expected answer', () =>
      expect(sjcl.encDet(keys.kEnc, keys.kMac, keys.kIv, plaintext),
          byteArrayEquals(toByteArray([-87, -64, 101, 73, 55, -23, 111, 34, -25, 112, 94, -114, -29, -56, 79, -106, 103, -107, 91,
                                       123, -107, -43, 95, -75, -71, -35, -30, -4, 95, -91, -128, -87, 52, -93, 98, -39, -25, 20,
                                       15, -57, -56, -78, -30, -4, 109, -125, 116, 27, 32, -63, 52, 37, -22, -9, 36, -31, -31, 123,
                                       39, -97, 37, 101, -94, -50]))));
}