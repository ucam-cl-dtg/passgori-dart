/**
 * Helper functions for sjcl integration
 */

/** @fileOverview HMAC implementation.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/** HMAC with the specified hash function.
 * @constructor
 * @param {bitArray} key the key for HMAC.
 */
sjcl.misc.hmacsha1 = function (key) {
  this._hash = Hash = sjcl.hash.sha1;
  var exKey = [[],[]], i,
      bs = Hash.prototype.blockSize / 32;
  this._baseHash = [new Hash(), new Hash()];

  if (key.length > bs) {
    key = Hash.hash(key);
  }
  
  for (i=0; i<bs; i++) {
    exKey[0][i] = key[i]^0x36363636;
    exKey[1][i] = key[i]^0x5C5C5C5C;
  }
  
  this._baseHash[0].update(exKey[0]);
  this._baseHash[1].update(exKey[1]);
};

/** HMAC with the specified hash function.  Also called encrypt since it's a prf.
 * @param {bitArray|String} data The data to mac.
 */
sjcl.misc.hmacsha1.prototype.encrypt = sjcl.misc.hmacsha1.prototype.mac = function (data) {
  var w = new (this._hash)(this._baseHash[0]).update(data).finalize();
  return new (this._hash)(this._baseHash[1]).update(w).finalize();
};