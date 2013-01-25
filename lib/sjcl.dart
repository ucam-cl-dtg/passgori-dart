library sjcl;

import 'package:js/js.dart' as js;
import 'dart:scalarlist';
import 'dart:crypto';
import 'package:nigori/nigori.dart';

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
   * Must be called in a js scope
   */
  _toSjclBits(ByteArray array){
    return sjcl.codec.hex.toBits(CryptoUtils.bytesToHex(new Uint8List.view(array)));
  }
  /**
   * Must be called in a js scope
   * [bits] sjcl bit array
   */
  ByteArray _fromSjclBits(var bits){
    // cribbed from sjcl.codec.bytes.fromBits
    int bitLength = sjcl.bitArray.bitLength(bits);
    Int8List bytesAnswer = new Int8List(bitLength~/8);
    var tmp;
    for (int i=0; i<bitLength/8;++i){
      if((i&3) == 0){
        tmp = bits[i/4];
      }
      bytesAnswer[i] = tmp >> 24;
      tmp <<= 8;
    }
    return bytesAnswer.asByteArray();
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
    ByteArray bytesAnswer;
    js.scoped((){
      var answer = sjcl.misc.pbkdf2(_toSjclBits(password),
          _toSjclBits(salt),
          count,length*8/*sjcl wants bits*/,sjcl.misc.hmacsha1);
      bytesAnswer = _fromSjclBits(answer);
    });
    return bytesAnswer;
  }

  ByteArray hmac(ByteArray text, ByteArray key){
    ByteArray bytesAnswer;
    js.scoped((){
      print('plaintext: ${byteArrayToString(text)}');
      print('hmackey: ${byteArrayToString(key)}');
      js.Proxy hmac = new js.Proxy(sjcl.misc.hmac,_toSjclBits(key));
      bytesAnswer = _fromSjclBits(hmac.encrypt(text));
      print('hmacBytes: ${byteArrayToString(bytesAnswer)}');
    });
    return bytesAnswer;
  }

  ByteArray enc(ByteArray encKey, ByteArray macKey, ByteArray plaintext) {
    ByteArray list;
    js.scoped((){
      js.Proxy iv = sjcl.random.randomWords(4,0);// 4 words of randomness => 16 bytes
      list = _enc(encKey, macKey, plaintext, iv);
    });
    return list;
  }

  ByteArray encDet(ByteArray encKey, ByteArray macKey, ByteArray ivKey, ByteArray plaintext) {
    ByteArray list;
    js.scoped((){
      Uint8List xoredHmac = new Uint8List(16);
      ByteArray hmacBytes = hmac(plaintext,ivKey);
      for(int i=0, j = 16; i < 16; ++i,++j){
        xoredHmac[i] = hmacBytes.getUint8(i) ^ hmacBytes.getUint8(j);
      }
      print('xoredHmac: ${byteArrayToString(xoredHmac.asByteArray())}');
      list = _enc(encKey, macKey, plaintext, _toSjclBits(xoredHmac.asByteArray()));
      print('encrypted: ${byteArrayToString(list)}');
    });
    return list;
  }

  /**
   * Must be called inside a js scope
   * [iv] is a Proxy to 16 bytes of sjcl bitarray containing the iv to use for encryption
   */
  ByteArray _enc(ByteArray encKey, ByteArray macKey, ByteArray plaintext, js.Proxy iv) {
    Int8List list;
    js.Proxy aes = new js.Proxy(sjcl.cipher.aes,_toSjclBits(encKey));
      var ciphertext = sjcl.mode.cbc.encrypt(aes,_toSjclBits(plaintext),iv,[]);
      ByteArray ciphertextB = _fromSjclBits(ciphertext);
      ByteArray hmac = this.hmac(ciphertextB,macKey);
      ByteArray ivB = _fromSjclBits(iv);
      list = new Int8List(ivB.lengthInBytes() + ciphertextB.lengthInBytes() + hmac.lengthInBytes());
      int offset = 0;
      for(int i = 0; i<ivB.lengthInBytes();++i,++offset){
        list[offset] = ivB.getInt8(i);
      }
      for (int i = 0; i<ciphertextB.lengthInBytes();++i,++offset){
        list[offset] = ciphertextB.getInt8(i);
      }
      for (int i = 0; i< hmac.lengthInBytes();++i,++offset){
        list[offset] = hmac.getInt8(i);
      }
    return list.asByteArray();
  }
}
