
library PassgoriExtension;

import 'dart:html';
import 'dart:scalarlist';

import 'package:js/js.dart' as js;
import 'package:nigori/nigori.dart';


//part 'pageinject.dart';

var sjcl;
void main() {
  js.scoped(() {
    var context = js.context;
    sjcl = js.retain(context.sjcl);
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



ByteArray pbkdf2(ByteArray password, ByteArray salt, int count, int length) {
  js.scoped((){
    return sjcl.misc.pbkdf2(password,salt,count,length,sjcl.misc.hmacsha1);
  });
}
ByteArray hmac(ByteArray text, var key){//TODO(drt24) type of key
  js.scoped((){
    var hmac = new sjcl.misc.hmac(key);
    return hmac.encrypt(text);//TODO(drt24) invalid type of argument
  });
}
class NigoriKeys {
  var kUser, kEnc, kMac, kIv;

  NigoriKeys.derive(String username, String password, String serverName){
    
    sUser = pbkdf2();
  }
}

