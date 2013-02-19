
library nigori;

import 'dart:json';
import 'dart:html';
import 'package:json_object/json_object.dart';
import 'package:json_object/src/mirror_based_serializer.dart';
import 'package:nigori/nigori.dart';
import 'package:nigori/dsa.dart';
import 'package:PassgoriExtension/keys.dart';

class NigoriHttpJsonClient {
  final NigoriKeys keys;
  final String server_name;
  String _url;
  NigoriHttpJsonClient(this.keys,this.server_name){
    this._url = "http://${server_name}/nigori";
  }

  bool authenticate(){
    const String command = 'authenticate';
    AuthenticateRequest auth = _generateAuth(command);
    objectToJson(auth).then((jsonStr) => _sendMessage(jsonStr,command));
  }
  bool register() {
    const String command = 'register';
    RegisterRequest register = new RegisterRequest(bigIntegerToByteArray(keys.dsaKeys.publicKey),toByteArray([]));
    objectToJson(register).then((jsonStr) => _sendMessage(jsonStr,command));
  }
  AuthenticateRequest _generateAuth(String command,[List<int> message]) {
    if (null == message){
      message = [];
    }
    NigoriNonce nonce = new NigoriNonce();
    DsaSignature sig = keys.sign(byteconcat([server_name,nonce.timestamp,nonce.random,command,message]));
    var auth = new AuthenticateRequest(keys.dsaPublicHash,
        byteconcat([sig.r,sig.s]),nonce.toByteArray(),server_name);
    return auth;
  }
  _sendMessage(String json,String method){
    HttpRequest httpRequest =new HttpRequest();
    
    // add an event handler that is called when the request finishes
    httpRequest.onReadyStateChange.listen((_) {
      if (httpRequest.readyState == HttpRequest.DONE){
        if (httpRequest.status == 200 || httpRequest.status == 0) {
          print("Success (${method}): ${httpRequest.responseText}"); // called when the POST successfully completes
        } else {
          print("Failure: ${httpRequest.status} ${httpRequest.responseText}");
        }
      }
    });
    httpRequest.open("POST", "${_url}/${method}",false);
    httpRequest.setRequestHeader("Content-Type", "application/json");
    httpRequest.send(json);
  }
}