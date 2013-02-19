library keys;

import 'package:PassgoriExtension/sjcl.dart';
import 'package:nigori/nigori.dart';
import 'package:nigori/dsa.dart';
import 'dart:scalarlist';
import 'dart:crypto';

class NigoriKeys {
  var kUser, kEnc, kMac, kIv;
  DsaKeyPair _dsaKeyPair;
  Dsa _dsa;
  ByteArray _dsaPublicHash;

  NigoriKeys.derive(String username, String password, String serverName){
    Sjcl sjcl = new Sjcl();
    ByteArray userSalt = NigoriConstants.Usersalt;
    if (userSalt == null){
      throw new StateError("user salt is null");
    }
    ByteArray sUser = sjcl.pbkdf2(byteconcat([username,serverName]),userSalt,NigoriConstants.Nsalt,NigoriConstants.Bsuser);
    if (sUser == null){
      throw new StateError("sUser is null");
    }
    ByteArray bytePassword = toBytes(password);
    kUser = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Nuser, NigoriConstants.Bkdsa);
    kEnc = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Nenc, NigoriConstants.Bkenc);
    kMac = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Nmac, NigoriConstants.Bkmac);
    kIv = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Niv, NigoriConstants.Bkiv);
    _dsa = new Dsa();
    _dsaKeyPair = _dsa.fromSecret(byteArrayToBigInteger(kUser));
    SHA1 digest = new SHA1();
    digest.add(_dsaKeyPair.publicKey.toByteArray());
    _dsaPublicHash = toByteArray(digest.close());
  }

  DsaKeyPair get dsaKeys => _dsaKeyPair;
  ByteArray get dsaPublicHash => _dsaPublicHash;
  
  DsaSignature sign(ByteArray message){
    return _dsa.sign(message, dsaKeys.privateKey);
  }
}