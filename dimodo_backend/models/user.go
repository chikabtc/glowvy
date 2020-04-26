package models

import (
	"database/sql"
	"dimodo_backend/utils"
	"dimodo_backend/utils/hash"
	"dimodo_backend/utils/null"
	"encoding/json"
	"fmt"
	"regexp"
	"strings"
	"time"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gchaincl/dotsql"
)

// //UserService is a set of methods used to manipulate and work with account model
type UserService interface {
	//Authenticate will verify the provided email address and password are correct. If they are correct, the user corresponding to theat email will be returned. Otherwise you will receive either: ErrNotFound, ErrPassworldInvalid, or another error if something goes wrong.
	// Authenticate(email, password string) (*User, error)
	HandleUserName(FullName, UserName string) (out string)
	HandleDisplayName(Full_name, Display_name string) string
	UserDB
}

type UserDB interface {
	SignUp(user *User) error
	SignIn(user *User) error
	SignInAuth(user *User) error

	SignUpWithFacebook(user *User) error
	HanleAfterLoginFacebook(content []byte) (*User, error)
	ForgotPassword(forgot *ForgotPassword) (*PinResetPassword, error)
	ResetPassword(pw *Password, pin *PinResetPassword) error
	CheckPinPassword(pin *PinResetPassword) error

	SignUpAuthGoogle(user *User) error
	HanleAfterLoginGoogle(content []byte) (*User, error)
}

type userService struct {
	DB  *sql.DB
	dot *dotsql.DotSql

	hmac       hash.HMAC
	emailRegex *regexp.Regexp
}

func NewUserService(db *sql.DB, hmacKey string) UserService {
	userDot, _ := dotsql.LoadFromFile("sql/queries/user.pgsql")

	return &userService{
		DB:         db,
		dot:        userDot,
		hmac:       hash.NewHMAC(hmacKey),
		emailRegex: regexp.MustCompile(`^[0-9]*[A-Za-z][A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$`),
	}
}

type User struct {
	Id              int         `json:"id,omitempty"`
	User_name       string      `json:"User_name,omitempty"`
	Email           null.String `json:"email,omitempty"`
	Email_verified  bool        `json:"email_verified,omitempty"`
	Password        string      `json:"password,omitempty"`
	Full_name       string      `json:"full_name,omitempty"`
	Display_name    string      `json:"display_name,omitempty"`
	Birthday        time.Time   `json:"birthday,omitempty"`
	Phone           null.String `json:"phone,omitempty"`
	Gender          int         `json:"gender,omitempty"`
	Avatar          string      `json:"avatar,omitempty"`
	Active          bool        `json:"active,omitempty"`
	Rid             int         `json:"rid,omitempty"`
	Role            Roles       `json:"role,omitempty"`
	Sid             int         `json:"sid,omitempty"`
	Token           string      `json:"token,omitempty"`
	Xid             string      `json:"xid,omitempty"`
	Signer          string      `json:"signer,omitempty"`
	Facebook_id     string      `json:"facebook_id,omitempty"`
	Facebook_logged bool        `json:"facebook_logged,omitempty"`
	Google_id       string      `json:"google_id,omitempty"`
	Google_logged   bool        `json:"google_logged,omitempty"`
	Creater         int         `json:"creater,omitempty"`
	Session         string      `json:"session,omitempty"`
	Created_at      int         `json:"created_at,omitempty"`
	Updated_at      int         `json:"updated_at,omitempty"`
	Deleted_at      int         `json:"deleted_at,omitempty"`
}

type Roles struct {
	Id         int    `json:"id,omitempty"`
	Name       string `json:"name,omitempty"`
	Active     bool   `json:"active,omitempty"`
	Created_at int    `json:"created_at,omitempty"`
	Updated_at int    `json:"updated_at,omitempty"`
	Deleted_at int    `json:"deleted_at,omitempty"`
}

type Password struct {
	Current string `json:"current"`
	New     string `json:"new"`
	Confirm string `json:"confirm_new"`
}

type ForgotPassword struct {
	Email  string `json:"email"`
	Domain string `json:"domain"`
}

type Auth struct {
	Id      int    `json:"id,omitempty"`
	Rid     int    `json:"rid,omitempty"`
	Sid     int    `json:"sid,omitempty"`
	Xid     string `json:"xid,omitempty"`
	Session string `json:"session,omitempty"`
	Token   string `json:"token,omitempty"`
}
type PinResetPassword struct {
	Id         int    `json:"id"`
	Id_account int    `json:"id_account"`
	Pin        string `json:"pin"`
	Failed     int    `json:"failed"`
	Creater    int    `json:"creater"`
}

const (
	CountDefault = 24
	RoleDefault  = 1
)

func (us *userService) SignUp(user *User) error {

	row, err := us.dot.QueryRow(us.DB, "QuerySignUpUser",
		user.User_name,
		user.Email,
		user.Password,
		user.Full_name,
		user.Display_name,
		user.Birthday,
		user.Phone,
		user.Avatar,
		user.Active,
		user.Rid,
		user.Token,
		user.Xid,
		user.Signer,
		user.Session)

	row.Scan(&user.Id, &user.Sid, &user.Xid)
	return err
}

func (us *userService) ForgotPassword(forgot *ForgotPassword) (*PinResetPassword, error) {
	var pin PinResetPassword
	row, err := us.dot.QueryRow(us.DB, "QueryForgotPassword", forgot.Email)
	if err != nil {
		bugsnag.Notify(err)
		return nil, ErrEmailNotFound
	}
	row.Scan(&pin.Id, &pin.Id_account, &pin.Pin)
	return &pin, nil
}
func (us *userService) CheckPinPassword(pin *PinResetPassword) error {
	fmt.Println(pin)
	row, err := us.dot.QueryRow(us.DB, "QueryCheckPin", pin.Id, pin.Id_account, pin.Pin)
	if err != nil {
		bugsnag.Notify(err)
		return ErrPinNotFound
	}
	row.Scan(&pin.Id)
	return nil
}

func (us *userService) ResetPassword(pw *Password, pin *PinResetPassword) error {
	_, err := us.dot.Exec(us.DB, "ChangePasswordQuery", pin.Id_account, utils.EncryptPassword(pw.New))
	if err != nil {
		bugsnag.Notify(err)
		return err
	}
	return nil
}

//              Handle              //
func (us *userService) HandleUserName(FullName, UserName string) (out string) {
	reg := regexp.MustCompile(`[^a-zA-Z0-9]+`)
	fullname := utils.UnAccentVietNamese(FullName)
	fullname = reg.ReplaceAllString(fullname, "")
	username := reg.ReplaceAllString(UserName, "")
	if !utils.IsEmpty(username) {
		out = username
	}
	if utils.IsEmpty(username) && !utils.IsEmpty(fullname) {
		out = fullname + utils.RandomNumberString(8)
	}
	if utils.IsEmpty(username) && utils.IsEmpty(fullname) {
		number := utils.RandomIntSize(6, 12)
		out = utils.RandomLowercase(number) + utils.RandomNumberString(8)
	}
	if utils.IsNumber(username) && !utils.IsEmpty(fullname) {
		out = fullname + username
	}
	if utils.IsNumber(out) {
		number := utils.RandomIntSize(6, 12)
		out = utils.RandomLowercase(number) + out
	}
	return strings.ToLower(out)
}

func (us *userService) HandleDisplayName(full_name, display_name string) string {
	if !utils.IsEmpty(display_name) {
		return display_name
	}
	return full_name
}

func (us *userService) SignIn(user *User) error {
	var TempPassword = utils.EncryptPassword(user.Password)
	// fmt.Println(TempPassword)
	utils.PrintJson(user)
	row, err := us.dot.QueryRow(us.DB, "QuerySignIn", user.Email)
	row.Scan(
		&user.Id,
		&user.User_name,
		&user.Email,
		&user.Password,
		&user.Full_name,
		&user.Display_name,
		&user.Phone,
		&user.Avatar,
		&user.Birthday,
		&user.Rid,
		&user.Xid,
		&user.Sid,
		&user.Token,
		&user.Session,
		&user.Signer,
		&user.Active,
	)
	if err != nil {
		bugsnag.Notify(err)
		return err
	}
	if !user.Active {
		return fmt.Errorf("User has been disabled")
	}
	if TempPassword == user.Password {
		return nil
	} else {
		return fmt.Errorf("Incorrect Password")
	}
}

func (us *userService) HanleAfterLoginGoogle(content []byte) (*User, error) {
	var user User
	var contents map[string]interface{}
	err := json.Unmarshal(content, &contents)
	utils.PrintJson(contents)
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Errorf("Error Parse map")
		return nil, msgError
	}
	// print("google contents: ", email)

	_email, oke := contents["email"]
	if !oke {
		return nil, ErrEmailNotFound
	}
	email := fmt.Sprintf("%v", _email)
	print("google email: ", email)

	var check bool

	row, err := us.dot.QueryRow(us.DB, "CheckEmailQuery", email)
	row.Scan(&check)
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Errorf("Error in server: %s", err.Error())
		return nil, msgError
	}

	user.Email = null.StringFromPtr(&email)
	if check {
		err = us.SignInAuth(&user)
	}
	if !check {
		_FullName, oke := contents["name"]
		if !oke {
			return nil, ErrEmailContentNotFound
		}
		FullName := fmt.Sprintf("%v", _FullName)
		print("google fullName: ", FullName)

		_id, oke := contents["id"]
		if !oke {

			return nil, ErrEmailNotFound
		}
		ID := fmt.Sprintf("%v", _id)
		user.Google_logged = true
		user.Google_id = ID
		user.Full_name = FullName
		user.User_name = us.HandleUserName(user.Full_name, user.User_name)
		user.Full_name = utils.CombineSpace(user.Full_name)
		user.Display_name = us.HandleDisplayName(user.Full_name, user.Display_name)
		user.Session = utils.Session()
		user.Token = utils.Token()
		user.Xid = utils.Session64() + user.Token
		user.Signer = user.Xid
		user.Active = true
		user.Rid = RoleDefault
		if err := us.SignUpAuthGoogle(&user); err != nil {
			msgError := fmt.Errorf("Error in server: %s", err.Error())
			return nil, msgError
		}
	}
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Errorf("Error in server: %s", err.Error())
		return nil, msgError
	}
	return &user, nil
}

func (us *userService) SignUpAuthGoogle(user *User) error {
	row, err := us.dot.QueryRow(us.DB, "QuerySignUpAuthGoogle",
		user.User_name,
		user.Email,
		user.Google_id,
		user.Full_name,
		user.Display_name,
		user.Birthday,
		user.Phone,
		user.Avatar,
		user.Active,
		user.Rid,
		user.Token,
		user.Xid,
		user.Signer,
		user.Session,
		user.Google_logged)
	row.Scan(&user.Id, &user.Sid, &user.Xid)
	return err
}

func (us *userService) SignInAuth(user *User) error {
	row, err := us.dot.QueryRow(us.DB, "QuerySignInAuth", user.Email)
	row.Scan(
		&user.Id,
		&user.User_name,
		&user.Email,
		&user.Full_name,
		&user.Display_name,
		&user.Phone,
		&user.Avatar,
		&user.Birthday,
		&user.Rid,
		&user.Xid,
		&user.Sid,
		&user.Token,
		&user.Session,
		&user.Signer,
		&user.Active,
	)
	return err
}

func (us *userService) HanleAfterLoginFacebook(content []byte) (*User, error) {
	var user User
	var contents map[string]interface{}
	err := json.Unmarshal(content, &contents)
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Errorf("Error Parse map")
		return nil, msgError
	}
	// print("FB content:", contents["email"])
	_email, oke := contents["email"]
	if !oke {
		return nil, ErrEmailNotFound
	}
	email := fmt.Sprintf("%v", _email)
	fmt.Println("fb email", email)
	var check bool
	row, err := us.dot.QueryRow(us.DB, "CheckEmailQuery", email)
	row.Scan(&check)
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Errorf("Error in server: %s", err.Error())
		return nil, msgError
	}

	user.Email = null.StringFromPtr(&email)
	if check {
		err = us.SignInAuth(&user)
	}
	if !check {
		_FullName, oke := contents["name"]
		if !oke {

			return nil, ErrEmailNotFound
		}
		FullName := fmt.Sprintf("%v", _FullName)
		fmt.Println("fb _FullName", FullName)

		_id, oke := contents["id"]
		if !oke {

			return nil, ErrEmailNotFound
		}
		ID := fmt.Sprintf("%v", _id)
		user.Facebook_logged = true
		user.Facebook_id = ID
		user.Full_name = FullName
		user.User_name = us.HandleUserName(user.Full_name, user.User_name)
		user.Full_name = utils.CombineSpace(user.Full_name)
		user.Display_name = us.HandleDisplayName(user.Full_name, user.Display_name)
		user.Session = utils.Session()
		user.Token = utils.Token()
		user.Xid = utils.Session64() + user.Token
		user.Signer = user.Xid
		user.Active = true
		user.Rid = RoleDefault
		if err := us.SignUpWithFacebook(&user); err != nil {
			msgError := fmt.Errorf("Error in server: %s", err.Error())
			return nil, msgError
		}
	}
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Errorf("Error in server: %s", err.Error())
		return nil, msgError
	}
	return &user, nil
}

func (us *userService) SignUpWithFacebook(user *User) error {
	fmt.Printf("User Name: %v \n", user.User_name)
	row, err := us.dot.QueryRow(us.DB, "QuerySignUpAuthFaceBook",

		user.User_name,
		user.Email,
		user.Facebook_id,
		user.Full_name,
		user.Display_name,
		user.Birthday,
		user.Phone,
		user.Avatar,
		user.Active,
		user.Rid,
		user.Token,
		user.Xid,
		user.Signer,
		user.Session,
		user.Facebook_logged)
	err = row.Scan(&user.Id, &user.Sid, &user.Xid)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("QuerySignUpAuthFaceBook,", err)
		msgError := fmt.Errorf("Error in server: %s", err.Error())
		return msgError
	}
	return err
}
