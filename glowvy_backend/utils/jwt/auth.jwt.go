package jwt

import (
	"dimodo_backend/models"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/bugsnag/bugsnag-go"
	"github.com/dgrijalva/jwt-go"
)

const (
	secret_key             = "5DlTCGYMvSQthopb7figr8Nj9WHZsywJd6P1FKmeUuIBzqROLE203aAkV4cnXx"
	password_key           = "BDdj5htFONoZpUeErXMsTfbI01YVKQmc7l9Ai2vaqnCH8uG6Sgx43RPJwLkWyz"
	reset_password_key     = "5X0Hq3GQWMsfeTmDPtnCOwU1Y9pvlB8j7gL4VAcNESbFKhZoIxkJuRiy6r2adz"
	reset_password_pin_key = "5X0Hq3GQWMsfeTmDPtnCOwU1Y9pvlB8j7gL4VAcNESbFKhZoIxkJuRiy6r2adz"
)

var ResetPasswordPinKey = []byte(reset_password_pin_key)
var SecretKey = []byte(secret_key)
var ResetPasswordKey = []byte(reset_password_key)

//todo: remove model user to make it modular package
func Generate(u *models.User) (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id"] = &u.Id
	claims["rid"] = &u.Rid
	claims["sid"] = &u.Sid
	claims["session"] = &u.Session
	claims["token"] = &u.Token
	claims["xid"] = &u.Xid
	claims["exp"] = time.Now().Add(time.Hour * (24 * 30)).Unix()
	claims["iat"] = time.Now().Unix()
	tokenString, err := token.SignedString(SecretKey)
	if err != nil {
		bugsnag.Notify(err)
		return "", err
	}
	return tokenString, nil
}

func GenerateResetPassword(id int) (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id_account"] = id
	claims["exp"] = time.Now().Add(time.Minute * 15).Unix()
	claims["iat"] = time.Now().Unix()
	tokenString, err := token.SignedString(ResetPasswordKey)
	if err != nil {
		bugsnag.Notify(err)
		return "", err
	}
	return tokenString, nil
}

func RefreshToken() (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["exp"] = time.Now().Add(time.Hour * (24 * 30)).Unix()
	claims["iat"] = time.Now().Unix()
	refreshToken, err := token.SignedString(SecretKey)
	if err != nil {
		bugsnag.Notify(err)
		return "", err
	}
	return refreshToken, nil
}

func PayloadResetPassword(pin *models.PinResetPassword, r *http.Request) error {
	Token := r.Header.Get("TokenResetPassword")
	if Token != "" {
		token, err := jwt.Parse(Token, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("There was an error in Authorization")
			}
			return ResetPasswordKey, nil
		})
		if err != nil {
			bugsnag.Notify(err)
			msgErr := fmt.Errorf("Invalid Token-ResetPassword")
			return msgErr
		}
		if token.Valid {
			claims, _ := token.Claims.(jwt.MapClaims)
			pin.Id_account = int(claims["id_account"].(float64))
			return nil
		}
	}
	return fmt.Errorf("Not Token-ResetPassword")
}

func GenerateResetPasswordPin(id_pin, id_user int) (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id_pin"] = id_pin
	claims["id_account"] = id_user
	claims["exp"] = time.Now().Add(time.Minute * 15).Unix()
	claims["iat"] = time.Now().Unix()
	tokenString, err := token.SignedString(ResetPasswordPinKey)
	if err != nil {
		bugsnag.Notify(err)
		return "", err
	}
	return tokenString, nil
}

//move the model to this
func PayloadResetPasswordPin(pin *models.PinResetPassword, r *http.Request) error {
	Token := r.Header.Get("TokenPinResetPassword")
	if Token != "" {
		token, err := jwt.Parse(Token, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("There was an error in Authorization")
			}
			return ResetPasswordPinKey, nil
		})

		if err != nil {
			bugsnag.Notify(err)
			msgErr := fmt.Errorf("Invalid Token-ResetPassword")
			return msgErr
		}

		if token.Valid {
			claims, _ := token.Claims.(jwt.MapClaims)
			pin.Id = int(claims["id_pin"].(float64))
			pin.Id_account = int(claims["id_account"].(float64))
			return nil
		}
	}
	return fmt.Errorf("Not Token-ResetPassword")
}

func Payload(r *http.Request) *models.Auth {
	var auth models.Auth
	AuthorizationHeader := r.Header.Get("Authorization")

	BearerToken := strings.Split(AuthorizationHeader, "Bearer")
	Token := strings.TrimSpace(BearerToken[1])
	token, _ := jwt.Parse(Token, func(token *jwt.Token) (interface{}, error) {
		return SecretKey, nil
	})
	// fmt.Println("payload authHeader", AuthorizationHeader)
	claims, _ := token.Claims.(jwt.MapClaims)
	auth.Id = int(claims["id"].(float64))
	auth.Rid = int(claims["rid"].(float64))
	auth.Sid = int(claims["sid"].(float64))
	auth.Xid, _ = claims["xid"].(string)
	auth.Session, _ = claims["session"].(string)
	auth.Token, _ = claims["token"].(string)
	return &auth
}
