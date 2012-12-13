
library PassgoriExtension;

import 'dart:html';

import 'package:js/js.dart' as js;
import 'package:PassgoriExtension/sjcl.dart';


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
  });
}
