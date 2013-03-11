
library nigori;

import 'dart:json';
import 'dart:html';
import 'dart:async';
import 'dart:scalarlist';
import 'package:json_object/json_object.dart';
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

  Future<bool> register() {
    const String command = 'register';
    RegisterRequest register = new RegisterRequest(bigIntegerToByteArray(keys.dsaKeys.publicKey),toByteArray([]));
    Completer completer = new Completer();
    objectToJson(register)
      .then((jsonStr) {
        _sendMessage(jsonStr,command)
          .then((response) => completer.complete(true))
          .catchError((error) => completer.completeError(error));
      })
      .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<bool> authenticate(){
    const String command = 'authenticate';
    return _request(command,
        (auth) => auth,
        (response) => true);
  }

  Future<bool> unregister(){
    const String command = 'unregister';
    return _request(command,
        (auth) => new UnregisterRequest(auth),
        (response) => true);
  }

  Future<GetIndicesResponse> getIndices() {
    const String command = 'get-indices';
    return _request(command,
        (auth) => new GetIndicesRequest(auth),
        (response) => new GetIndicesResponse.fromJsonString(response));
  }

  Future<GetResponse> get(ByteArray index, [ByteArray revision]) {
    const String command = 'get';
    return _request(command,
        (auth) => new GetRequest(auth,index,revision),
        (response) => new GetResponse.fromJsonString(response),
        [index, revision]);
  }

  Future<GetRevisionsResponse> getRevisions(ByteArray index){
    const String command = 'get-revisions';
    return _request(command,
        (auth) => new GetRevisionsRequest(auth,index),
        (response) => new GetRevisionsResponse.fromJsonString(response),
        [index]);
  }

  Future put(ByteArray index, ByteArray revision, ByteArray value){
    const String command = 'put';
    return _request(command,
        (auth) => new PutRequest(auth,index,revision,value),
        (response) => true,
        [index, revision, value]);
  }

  Future delete(ByteArray index){
    const String command = 'delete';
    return _request(command,
        (auth) => new DeleteRequest(auth, index),
        (response) => true,
        [index]);
  }

  //TODO(drt24) provide better type information than Function
  Future _request(String command, Function generateRequest, Function generateResponse,[List<int> message]) {
    AuthenticateRequest auth = _generateAuth(command,message);
    Object request = generateRequest(auth);
    Completer completer = new Completer();
    objectToJson(request)
      .then((jsonStr) {
          _sendMessage(jsonStr,command)
            .then((response) => completer.complete(generateResponse(response)))
            .catchError((error) => completer.completeError(error));
        })
      .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  AuthenticateRequest _generateAuth(String command,[List<dynamic> messageBytes]) {
    List<int> message;
    if (null == messageBytes){
      message = [];
    } else {
      message = byteconcatList(messageBytes);
    }
    NigoriNonce nonce = new NigoriNonce();
    DsaSignature sig = keys.sign(byteconcat([server_name,nonce.timestamp,nonce.random,command,message]));
    var auth = new AuthenticateRequest(keys.dsaPublicHash,
        byteconcat([sig.r,sig.s]),nonce.toByteArray(),server_name);
    return auth;
  }

  Future<String> _sendMessage(String json,String method){
    Completer completer = new Completer();
    HttpRequest httpRequest =new HttpRequest();
    // add an event handler that is called when the request finishes
    httpRequest.onReadyStateChange.listen((_) {
      if (httpRequest.readyState == HttpRequest.DONE){
        if (httpRequest.status == 200 || httpRequest.status == 0) {
          // called when the POST successfully completes
          completer.complete(httpRequest.responseText);
        } else {
          completer.completeError("${httpRequest.status} ${httpRequest.responseText}");
        }
      }
    });
    httpRequest.open("POST", "${_url}/${method}",false);
    httpRequest.setRequestHeader("Content-Type", "application/json");
    httpRequest.send(json);
    return completer.future;
  }
}