package hash

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"hash"
)

type HMAC struct {
	hmac hash.Hash
}

func NewHMAC(secretKey string) HMAC {
	h := hmac.New(sha256.New, []byte(secretKey))
	return HMAC{
		hmac: h,
	}
}

//Hash will hash the provided input string using HMAC with the secret key provided when the HMAC object was created.
func (h HMAC) Hash(rememberToken string) string {
	h.hmac.Reset()
	h.hmac.Write([]byte(rememberToken))
	//Sum appends the current hash to b and returns the resulting slice.
	b := h.hmac.Sum(nil)
	return base64.URLEncoding.EncodeToString(b)
}
