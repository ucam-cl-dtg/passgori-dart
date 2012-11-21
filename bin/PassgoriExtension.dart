
import 'dart:html';
import 'package:js/js.dart' as js;

/**
 * Refer to the Constants section of the RFC for the meaning of these constants
 **/
class NigoriConstants {
  final int Nsalt = 1000;
  final int Nuser = 1001;
  final int Nenc = 1002;
  final int Nmac = 1003;
  final int Niv = 1004;
  final int Nmaster = 1005;
  final int Bsuser = 16;
  final int Bkdsa = 16;
  final int Bkenc = 16;
  final int Bkmac = 16;
  final int Bkiv = 16;
  final int Bkmaster = 16;
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
    
  });
}