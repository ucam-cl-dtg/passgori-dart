import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:PassgoriExtension/keys.dart';
import 'package:nigori/nigori.dart';

void main() {
  useHtmlConfiguration();
  test('constants salt not null', () => expect(NigoriConstants.Usersalt,isNotNull));
  test('keyderivation', () => new NigoriKeys.derive("test","test","test"));
}