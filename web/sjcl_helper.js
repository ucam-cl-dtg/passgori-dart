/**
 * Helper functions for sjcl integration
 */

sjcl.misc.hmacsha1 = function (key) {
  sjcl.misc.hmac(key,sjcl.hash.sha1)
}