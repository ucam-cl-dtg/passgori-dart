library keys;

import 'package:PassgoriExtension/sjcl.dart';
import 'package:nigori/nigori.dart';
import 'dart:scalarlist';

class NigoriKeys {
  var kUser, kEnc, kMac, kIv;

  NigoriKeys.derive(String username, String password, String serverName){
    Sjcl sjcl = new Sjcl();
    ByteArray userSalt = NigoriConstants.Usersalt.asByteArray();
    if (userSalt == null){
      throw new StateError("user salt is null");
    }
    ByteArray sUser = sjcl.pbkdf2(byteconcat(username,serverName),userSalt,NigoriConstants.Nsalt,NigoriConstants.Bsuser);
    if (sUser == null){
      throw new StateError("sUser is null");
    }
    ByteArray bytePassword = toBytes(password);
    kUser = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Nuser, NigoriConstants.Bkdsa);
    kEnc = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Nenc, NigoriConstants.Bkenc);
    kMac = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Nmac, NigoriConstants.Bkmac);
    kIv = sjcl.pbkdf2(bytePassword, sUser, NigoriConstants.Niv, NigoriConstants.Bkiv);
  }
}