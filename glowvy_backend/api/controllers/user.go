package controllers

import (
	"context"
	"dimodo_backend/models"
	"dimodo_backend/utils"
	"dimodo_backend/utils/jwt"
	resp "dimodo_backend/utils/respond"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/Timothylock/go-signin-with-apple/apple"
	"github.com/bugsnag/bugsnag-go"
	"github.com/gorilla/mux"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/facebook"
	"golang.org/x/oauth2/google"
)

type User struct {
	us         models.UserService
	ms         models.MailService
	app_domain string
	app_name   string
	slack      *utils.Slack
}

func NewUser(us models.UserService, ms models.MailService, appName, appDomain string, slack *utils.Slack) *User {
	return &User{
		us:         us,
		ms:         ms,
		app_domain: appDomain,
		app_name:   appName,
		slack:      slack,
	}
}

var (
	oauthFacebook = &oauth2.Config{
		ClientID:     "540414906860627",
		ClientSecret: "9474ca8a9f13036437ad9683b15d2b71",
		RedirectURL:  "https://dimodo.app/oauth2/facebook/callback",
		Scopes:       []string{"public_profile", "email"},
		Endpoint:     facebook.Endpoint,
	}
	oauthGoogle = &oauth2.Config{
		ClientID:     "199541424798-3eta30c6bolpcrevspajcqm3ohh5ccnk.apps.googleusercontent.com",
		ClientSecret: "UR3JUEB-09aEBJP2y9ic8VOk",
		RedirectURL:  "https://dimodo.app/oauth2/google/callback",
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}
)

const (
	oauthGoogleUrlAPI   = "https://www.googleapis.com/oauth2/v2/userinfo?alt=json&access_token="
	oauthFacebookUrlAPI = "https://graph.facebook.com/me?fields=id,name,email,picture&access_token="
)

const (
	htmlIndex = `<html><body>
  Logged in with <a href="/oauth2/facebook/login">facebook</a>
  <a href="/oauth2/google/login">google</a>
  </body></html>
  `
)

//			______ SignUp ______			//
func (u *User) SignUp(w http.ResponseWriter, r *http.Request) {
	var user models.User
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&user); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()

	user.User_name = u.us.HandleUserName(user.Full_name, user.User_name)
	user.Full_name = utils.CombineSpace(user.Full_name)
	user.Display_name = u.us.HandleDisplayName(user.Full_name, user.Display_name)
	user.Session = utils.Session()
	user.Token = utils.Token()
	user.Xid = utils.Session64() + user.Token
	user.Signer = user.Xid
	// user.id
	user.Active = true
	user.Rid = models.RoleDefault
	user.Password = utils.EncryptPassword(user.Password)
	Token := make(map[string]interface{})
	if err := u.us.SignUp(&user); err != nil {
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Token["AccessToken"], _ = jwt.Generate(&user)
	Token["RefreshToken"], _ = jwt.RefreshToken()
	Token["Account"] = user

	resp.Json(w, r, http.StatusCreated, resp.WithSuccess(Token))

}

//			______ SignIn ______			//
func (u *User) SignIn(w http.ResponseWriter, r *http.Request) {
	var user models.User
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&user); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()
	if err := u.us.SignIn(&user); err != nil {
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Token := make(map[string]interface{})
	Token["AccessToken"], _ = jwt.Generate(&user)
	Token["RefreshToken"], _ = jwt.RefreshToken()
	Token["Account"] = user
	// Token["Claims"] = claims
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(Token))
}

//				Change Password 			//
func (u *User) ForgotPassword(w http.ResponseWriter, r *http.Request) {
	var forgot models.ForgotPassword
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&forgot); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()
	pin, err := u.us.ForgotPassword(&forgot)
	if err != nil {
		bugsnag.Notify(err)
		return
	}
	Access_Token, err := jwt.GenerateResetPassword(pin.Id_account)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusUnauthorized, resp.WithError(err.Error()))
		return
	}
	Token, err := jwt.GenerateResetPasswordPin(pin.Id, pin.Id_account)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusUnauthorized, resp.WithError(err.Error()))
		return
	}
	url_link := u.app_domain + "/reset-password.html" + "?token=" + Access_Token
	err = u.SendForgotPassword(forgot.Email, url_link, pin.Pin)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusUnauthorized, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(Token))
}

func (u *User) CheckPinPassword(w http.ResponseWriter, r *http.Request) {
	var pin models.PinResetPassword
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&pin); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()
	utils.PrintJson(pin)

	err := jwt.PayloadResetPasswordPin(&pin, r)

	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	utils.PrintJson(pin)
	err = u.us.CheckPinPassword(&pin)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Access_Token, err := jwt.GenerateResetPassword(pin.Id_account)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusUnauthorized, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(Access_Token))
}

func (u *User) ResetPassword(w http.ResponseWriter, r *http.Request) {
	var password models.Password
	decoder := json.NewDecoder(r.Body)

	if err := decoder.Decode(&password); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	fmt.Print(password)

	defer r.Body.Close()
	var pin models.PinResetPassword
	err := jwt.PayloadResetPassword(&pin, r)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	if err := u.us.ResetPassword(&password, &pin); err != nil {
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}

	resp.Json(w, r, http.StatusOK, resp.WithSuccess(true))
}

//OUATH2 Methods

func (u *User) HandleMain(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(htmlIndex))
}

func generateStateOauthCookie(w http.ResponseWriter) string {
	var expiration = time.Now().Add(20 * time.Minute)
	b := make([]byte, 16)
	rand.Read(b)
	state := base64.URLEncoding.EncodeToString(b)
	cookie := http.Cookie{Name: "oauthstate", Value: state, Expires: expiration}
	http.SetCookie(w, &cookie)
	return state
}

func (u *User) HandleFacebookLogin(w http.ResponseWriter, r *http.Request) {
	oauthStateString := generateStateOauthCookie(w)
	url := oauthFacebook.AuthCodeURL(oauthStateString)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func (u *User) HandleFacebookCallback(w http.ResponseWriter, r *http.Request) {
	oauthState, _ := r.Cookie("oauthstate")

	if r.FormValue("state") != oauthState.Value {
		msgError := fmt.Sprintf("Invalid oauth Facebook state")
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	content, err := u.getUserInfoFacebook(r.FormValue("state"), r.FormValue("code"))
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	//TODO: driver methods
	user, err := u.us.HanleAfterLoginFacebook(content)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Token := make(map[string]interface{})
	Token["AccessToken"], _ = jwt.Generate(user)
	Token["RefreshToken"], _ = jwt.RefreshToken()
	Token["Account"] = user
	respond, _ := json.Marshal(Token)
	w.Header().Set("Content-Type", "application/json")
	w.Write(respond)
}

func (u *User) getUserInfoFacebook(state string, code string) ([]byte, error) {

	token, err := oauthFacebook.Exchange(oauth2.NoContext, code)
	if err != nil {
		bugsnag.Notify(err)
		return nil, fmt.Errorf("code exchange failed: %s", err.Error())
	}
	fmt.Println(token.AccessToken)
	response, err := http.Get(oauthFacebookUrlAPI + token.AccessToken)
	if err != nil {
		bugsnag.Notify(err)
		return nil, fmt.Errorf("failed getting user info: %s", err.Error())
	}

	defer response.Body.Close()
	contents, err := ioutil.ReadAll(response.Body)
	if err != nil {
		bugsnag.Notify(err)
		return nil, fmt.Errorf("failed reading response body: %s", err.Error())
	}

	return contents, nil
}

func (u *User) HandleAccessTokenFacebook(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	token, oke := params["access_token"]
	if !oke {
		msgError := fmt.Sprintf("Invalid Access Token. Error: %s", oke)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	response, err := http.Get(oauthFacebookUrlAPI + token)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return

	}
	defer response.Body.Close()
	content, err := ioutil.ReadAll(response.Body)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	user, err := u.us.HanleAfterLoginFacebook(content)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Token := make(map[string]interface{})
	Token["AccessToken"], _ = jwt.Generate(user)
	Token["RefreshToken"], _ = jwt.RefreshToken()
	Token["Account"] = user
	respond, _ := json.Marshal(Token)
	w.Header().Set("Content-Type", "application/json")
	w.Write(respond)
}

func (u *User) HandleGoogleLogin(w http.ResponseWriter, r *http.Request) {
	oauthStateString := generateStateOauthCookie(w)
	url := oauthGoogle.AuthCodeURL(oauthStateString)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}
func (u *User) HandleAppleLogin(w http.ResponseWriter, r *http.Request) {
	var code = r.FormValue("code")
	var fullName = r.FormValue("fullName")
	fmt.Println("code", code)
	fmt.Println("fullName", fullName)
	// Your 10-character Team ID
	teamID := "249799HZZ2"

	// ClientID is the "Services ID" value that you get when navigating to your "sign in with Apple"-enabled service ID
	clientID := "app.dimodo.iOS"

	// Find the 10-char Key ID value from the portal
	keyID := "TJ4M6AW7S3"

	// The contents of the p8 file/key you downloaded when you made the key in the portal
	secret := `-----BEGIN PRIVATE KEY-----
	MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgOTIDhVVqrUhBGHjW
	NOogNHLBlUafYrG8cJFu584v3rqgCgYIKoZIzj0DAQehRANCAAQGJX8Lv5RDB1Vo
	PPqEJKKFqoJcoziL3oSgjXAzAIO658Ek6JoGNnt73NnDFg2pelSr3Qktr4F0ykDI
	+TlPyi1n
-----END PRIVATE KEY-----`

	// Generate the client secret used to authenticate with Apple's validation servers
	secret, err := apple.GenerateClientSecret(secret, teamID, clientID, keyID)
	if err != nil {
		fmt.Println("error generating secret: " + err.Error())
		return
	}

	// Generate a new validation client
	client := apple.New()

	vReq := apple.WebValidationTokenRequest{
		ClientID:     clientID,
		ClientSecret: secret,
		Code:         code,
		RedirectURI:  "https://glowvy.glitch.me/callbacks/sign_in_with_apple", // This URL must be validated with apple in your service
	}

	var response apple.ValidationResponse

	// Do the verification
	err = client.VerifyWebToken(context.Background(), vReq, &response)
	if err != nil {
		fmt.Println("error verifying: " + err.Error())
		return
	}

	if response.Error != "" {
		fmt.Println("apple returned an error: " + response.Error)
		return
	}

	// Get the unique user ID
	unique, err := apple.GetUniqueID(response.IDToken)
	if err != nil {
		fmt.Println("failed to get unique ID: " + err.Error())
		return
	}

	// Get the email
	claim, err := apple.GetClaims(response.IDToken)
	if err != nil {
		fmt.Println("failed to get claims: " + err.Error())
		return
	}

	email := (*claim)["email"]
	emailVerified := (*claim)["email_verified"]
	isPrivateEmail := (*claim)["is_private_email"]

	// Voila!
	fmt.Println("unique: ", unique)
	//if doesn't match, then save the unique code and email to the psql
	//if match, then retrieve user info
	_email := fmt.Sprintf("%v", email)
	fmt.Println("emailVerified: ", emailVerified)
	fmt.Println("isPrivateEmail: ", isPrivateEmail)

	user, err := u.us.HanleAfterLoginApple(_email, code, fullName)

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error", err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Token := make(map[string]interface{})
	Token["AccessToken"], _ = jwt.Generate(user)
	Token["RefreshToken"], _ = jwt.RefreshToken()
	Token["Account"] = user
	respond, _ := json.Marshal(Token)
	w.Header().Set("Content-Type", "application/json")
	w.Write(respond)
}

func (u *User) HandleGoogleCallback(w http.ResponseWriter, r *http.Request) {
	oauthState, _ := r.Cookie("oauthstate")
	if r.FormValue("state") != oauthState.Value {
		log.Println("invalid oauth google state")
		http.Redirect(w, r, "/", http.StatusTemporaryRedirect)
		return
	}
	content, err := u.getUserInfoGoogle(r.FormValue("state"), r.FormValue("code"))
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println(err.Error())
		http.Redirect(w, r, "/", http.StatusTemporaryRedirect)
		return
	}
	user, err := u.us.HanleAfterLoginGoogle(content)

	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Token := make(map[string]interface{})
	Token["AccessToken"], _ = jwt.Generate(user)
	Token["RefreshToken"], _ = jwt.RefreshToken()
	Token["Accoun	t"] = user
	respond, _ := json.Marshal(Token)
	w.Header().Set("Content-Type", "application/json")
	w.Write(respond)
}

func (u *User) getUserInfoGoogle(state string, code string) ([]byte, error) {

	token, err := oauthGoogle.Exchange(oauth2.NoContext, code)
	if err != nil {
		bugsnag.Notify(err)
		return nil, fmt.Errorf("code exchange failed: %s", err.Error())
	}
	fmt.Println(token.AccessToken)
	response, err := http.Get(oauthGoogleUrlAPI + token.AccessToken)
	if err != nil {
		bugsnag.Notify(err)
		return nil, fmt.Errorf("failed getting user info: %s", err.Error())
	}

	defer response.Body.Close()
	contents, err := ioutil.ReadAll(response.Body)
	if err != nil {
		bugsnag.Notify(err)
		return nil, fmt.Errorf("failed reading response body: %s", err.Error())
	}
	return contents, nil
}

func (u *User) HandleAccessTokenGoogle(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	token, oke := params["access_token"]
	if !oke {
		msgError := fmt.Sprintf("Invalid Access Token. Error: %s", oke)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	response, err := http.Get(oauthGoogleUrlAPI + token)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return

	}
	defer response.Body.Close()
	content, err := ioutil.ReadAll(response.Body)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	user, err := u.us.HanleAfterLoginGoogle(content)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("Error")
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	Token := make(map[string]interface{})
	Token["AccessToken"], _ = jwt.Generate(user)
	Token["RefreshToken"], _ = jwt.RefreshToken()
	Token["Account"] = user
	respond, _ := json.Marshal(Token)
	w.Header().Set("Content-Type", "application/json")
	w.Write(respond)
}

func (u *User) SubjectEmail(w http.ResponseWriter, r *http.Request) {
	var subject models.Subject
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&subject); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()

	if err := u.ms.CreateEmail(&subject); err != nil {
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusCreated, resp.WithSuccess(subject))
}
