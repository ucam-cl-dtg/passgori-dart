
import 'dart:html';
import 'dart:scalarlist';
import 'dart:utf';
import 'package:js/js.dart' as js;

/**
 * Refer to the Constants section of the RFC for the meaning of these constants
 **/
class NigoriConstants {
  static final int Nsalt = 1000;
  static final int Nuser = 1001;
  static final int Nenc = 1002;
  static final int Nmac = 1003;
  static final int Niv = 1004;
  static final int Nmaster = 1005;
  static final int Bsuser = 16;
  static final int Bkdsa = 16;
  static final int Bkenc = 16;
  static final int Bkmac = 16;
  static final int Bkiv = 16;
  static final int Bkmaster = 16;
  static final Usersalt = new Uint8List(9);

  static void init() {
  Usersalt[0] = 117;
  Usersalt[1] = 115;
  Usersalt[2] = 101;
  Usersalt[3] = 114;
  Usersalt[4] = 32;
  Usersalt[5] = 115;
  Usersalt[6] = 97;
  Usersalt[7] = 108;
  Usersalt[8] = 116;
  }
}

void main() {
  js.scoped(() {
    var context = js.context;
    var sjcl = js.retain(context.sjcl);
    var submitbutton = query('#submit');
    submitbutton.on.click.add((event){
      String key = query('#password').text;
      js.scoped((){
        String ciphertext = sjcl.encrypt(key,'plaintext');
        String plaintext = sjcl.decrypt(key,ciphertext);
        js.context.alert('ciphertext: $ciphertext plaintext: $plaintext');
        });
      });
    NigoriConstants.init();
  });
}