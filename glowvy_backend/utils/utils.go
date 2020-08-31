package utils

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"math/rand"
	"regexp"
	"strconv"
	"strings"
	"time"
	"unicode"

	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/norm"
)

const (
	//			Block => Không bao giờ thay đổi
	secret_key   = "5DlTCGYMvSQthopb7figr8Nj9WHZsywJd6P1FKmeUuIBzqROLE203aAkV4cnXx"
	password_key = "BDdj5htFONoZpUeErXMsTfbI01YVKQmc7l9Ai2vaqnCH8uG6Sgx43RPJwLkWyz"

	mail_key       = "mURWjxuNAFDsLrQ5v3VcHohbna6wPYI7elO1G9f0tdB8pgqTizEZKMXCkJy4S2"
	upload_key     = "OadZntowIRJVuxCLAMs85hpSTfYXKc9Bbqgr1F4vH7GUDizPQj3Ny6Wk0m2leE"
	read_image_key = "zOhbSdxsiDQJq30v4RWHtrCn2amF57pBXf6V8uA9kETcGIUo1MelNYKyLPZjwg"
	publIsh_key    = "XUi0A8GjITYfrNzanvDplKJMZyR4OuQgocFd9SHbsV1eP65q3hLEtxBmW2kwC7"
	block_key      = `."Lrqc2i!D*4CBlun;E^O'xzt$mN1Ps9%#<pvwRGZe3/oKI:,yYH7SWUXj6b0k5@J8a&F?>QfgVAMThd`
	//			full charter for Mix
	//			Open => Có thể  thay đổi
)

var RunesKey = []rune(publIsh_key)
var BlockKey = []rune(block_key)
var RunesNumber = []rune("0123456789")
var Lowercase = []rune("abcdefghijklmnopqrstuvwxyz")
var Uppercase = []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
var PasswordKey = []byte(password_key)

var SecretKey = []byte(secret_key)
var MailKey = []byte(mail_key)
var UploadKey = []byte(upload_key)

//			Mã Hóa Một Chiều Mật Khẩu
func EncryptPassword(password string) string {
	mac := hmac.New(sha256.New, PasswordKey)
	h := mac.Sum([]byte(password))
	return base64.StdEncoding.EncodeToString(h[:])
}

//			Chuỗi Ngẫu Nhiên Theo
func RandomRunes(length int, runes []rune) string {
	b := make([]rune, length)
	for i := range b {
		b[i] = runes[rand.Intn(len(runes))]
	}
	return string(b)
}

func RandomString(length int) string {
	return RandomRunes(length, RunesKey)
}

func RandomIntSize(min, max int) int {
	return min + rand.Intn(max-min)
}

func RandomBoolean() bool {
	value := RandomIntSize(0, 2)
	if value == 1 {
		return true
	}
	return false
}
func RandomIntSizeString(min, max int) string {
	return strconv.Itoa(min + rand.Intn(max-min))
}

func RandomLowercase(length int) string {
	return RandomRunes(length, Lowercase)
}

//			Tạo Chuỗi Số Number Ngẫu Nhiên Theo Độ Dài
func RandomNumberString(length int) string {
	return RandomRunes(length, RunesNumber)
}

//			Tạo Ngẫu Nhiên Chuổi 24 Kí Tự
func Token() string {
	return RandomRunes(24, RunesKey)
}

//			Lấy Thời Gian Cộng Với Ngẫu Nhiên 100
// 		=> 	Tạo Ra Chuỗi 19 Số Theo Thời Gian
func RandomFullTime() int64 {
	return time.Now().UnixNano() + int64(rand.Intn(100))
}
func Session() string {
	return strconv.FormatInt(RandomFullTime(), 10)
}
func Session64() string {
	return strconv.FormatInt(RandomFullTime(), 16)
}

// 			Kiểm tra phần tử đó có trong mảng chưa
func Contains(arr []string, str string) bool {
	for _, item := range arr {
		if str == item {
			return true
		}
	}
	return false
}

// 				Xóa Dấu Tiếng Việt
func UnAccentVietNamese(strAccent string) string {
	return UnAccent(strings.NewReplacer("Đ", "D", "đ", "d").Replace(strAccent))
}

func UnAccent(strAccent string) string {
	t := transform.Chain(norm.NFD, transform.RemoveFunc(IsMn), norm.NFC)
	result, _, _ := transform.String(t, strAccent)
	return result
}

func IsMn(r rune) bool {
	return unicode.Is(unicode.Mn, r) // Mn: nonspacing marks
}

// 			Xóa Kí Tự Đặt Biệt Trong Chuối
func RemoveSpecialCharacters(str string) string {
	// Make a Regex to say we only want letters and numbers
	reg, _ := regexp.Compile("[^a-zA-Z0-9]+")
	return reg.ReplaceAllString(str, "")
}

// Kiểm tra đó có phải là number không
func IsNumber(val string) bool {
	_, err := strconv.Atoi(val)
	if err == nil {
		return true
	}
	return false
}
func IsEmpty(val string) bool {
	return len(strings.TrimSpace(val)) == 0
}

func IsEmail(email string) bool {
	reg := regexp.MustCompile(`^[0-9]*[A-Za-z][A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$`)
	return reg.MatchString(email)
}

func IsGmail(email string) bool {
	reg := regexp.MustCompile(`^[0-9]*[A-Za-z][A-Za-z0-9._%-]+@gmail[.][A-Za-z]+$`)
	return reg.MatchString(email)
}

func IsNumeric(phone string) bool {
	reg := regexp.MustCompile(`^[0-9]+$`)
	return reg.MatchString(phone)
}

func IsIp(Addres string) bool {
	reg := regexp.MustCompile(`(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}`)
	return reg.MatchString(Addres)
}

func IsHostName(Addres string) bool {
	reg := regexp.MustCompile(`^[a-zA-Z0-9][a-zA-Z0-9\-\.]+[a-zA-Z0-9]$`)
	return reg.MatchString(Addres)
}

//		Gộp dấu cách hoặc khoảng trắng lại với nhau
func CombineSpace(val string) string {
	reg := regexp.MustCompile(`\s+`)
	return reg.ReplaceAllString(val, " ")
}

//			Mix passwourd			//
func MixEncode(password, SecretKey string) (result string) {
	PasswordToArray := strings.Split(password, "")
	for _, v := range PasswordToArray {
		idx := strings.Index(string(SecretKey), v)
		if idx == -1 {
			result += v
		} else {
			result += string(BlockKey[idx])
		}
	}
	return result
}

func MixDecode(password, SecretKey string) (result string) {
	PasswordToArray := strings.Split(password, "")
	for _, v := range PasswordToArray {
		idx := strings.Index(string(BlockKey), v)
		if idx == -1 {
			result += v
		} else {
			result += string([]byte(SecretKey)[idx])
		}
	}
	return result
}

func MixEncodeReverse(password string) (result string) {
	return MixEncode(password, reverse(block_key))
}

func MixDecodeReverse(password string) (result string) {
	return MixDecode(password, reverse(block_key))
}

func reverse(s string) string {
	chars := []rune(s)
	for i, j := 0, len(chars)-1; i < j; i, j = i+1, j-1 {
		chars[i], chars[j] = chars[j], chars[i]
	}
	return string(chars)
}
func PrintJson(obj interface{}) {
	temp, _ := json.MarshalIndent(obj, "", "  ")
	fmt.Println(string(temp))
}
func GetHoursPassed(start int64) int {
	startTime := strconv.Itoa(int(start))
	t1, err := strconv.ParseInt(startTime, 10, 64)
	if err != nil {
		panic(err)
	}
	tm := time.Unix(t1, 0)
	fmt.Println(tm)

	t2 := time.Now()
	du := t2.Sub(tm).Hours()
	fmt.Println("duration: ", du)
	return int(du)
}
