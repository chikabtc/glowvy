package rand

import (
	"crypto/rand"
	"encoding/base64"

	"github.com/bugsnag/bugsnag-go"
)

const RememberTokenBytes = 32

func RememberToken() (string, error) {
	return String(RememberTokenBytes)
}

// func Read(b []byte) (n int, err error)

func Bytes(n int) ([]byte, error) {
	b := make([]byte, n)
	_, err := rand.Read(b)
	if err != nil {
		bugsnag.Notify(err)
		return nil, err
	}
	return b, nil
}

func String(nBytes int) (string, error) {
	b, err := Bytes(nBytes)
	if err != nil {
		bugsnag.Notify(err)
		return "", err
	}
	return base64.URLEncoding.EncodeToString(b), nil
}

func NBytes(base64string string) (int, error) {
	b, err := base64.URLEncoding.DecodeString(base64string)
	if err != nil {
		bugsnag.Notify(err)
		return -1, err
	}
	return len(b), nil
}
