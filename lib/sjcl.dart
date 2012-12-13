library sjcl;

import 'package:js/js.dart' as js;
import 'dart:scalarlist';

/**
 * Encapsulate all the interactions with the sjcl library
 */
class Sjcl {
  var sjcl;
  Sjcl() {
    js.scoped((){
      sjcl = js.retain(js.context.sjcl);
    });
  }
  /**
   * [count] the number of iterations (must be at least 1000)
   * [length] in octets
   */
  ByteArray pbkdf2(ByteArray password, ByteArray salt, int count, int length) {
    if (password == null){
      throw new ArgumentError("Null password");
    }
    if ( salt == null) {
      throw new ArgumentError("Null salt");
    }
    if (count < 1000){
      throw new ArgumentError("Count too small, must be > 1000 but is $count");
    }
    if (length < 0){
      throw new ArgumentError("length must be > 0 but was $length");
    }
    if (sjcl == null){
      throw new StateError("sjcl null - can't talk to the crypto library");
    }
    Uint8List bytesAnswer;
    js.scoped((){
      var answer = sjcl.misc.pbkdf2(sjcl.codec.bytes.toBits(new Uint8List.view(password)),
          sjcl.codec.bytes.toBits(new Uint8List.view(salt)),
          count,length*8/*sjcl wants bits*/,sjcl.misc.hmacsha1);
      // cribbed from sjcl.codec.bytes.fromBits
      int bitLength = sjcl.bitArray.bitLength(answer);
      bytesAnswer = new Uint8List(length);
      var tmp;
      for (int i=0; i<bitLength/8;++i){
        if((i&3) === 0){
          tmp = answer[i/4];
        }
        bytesAnswer[i] = tmp >> 24;
        tmp <<= 8;
      }
    });
    return bytesAnswer.asByteArray();
  }

  ByteArray hmac(ByteArray text, var key){//TODO(drt24) type of key
    js.scoped((){
      var hmac = new sjcl.misc.hmac(key);
      return hmac.encrypt(text);//TODO(drt24) invalid type of argument
    });
  }
}
