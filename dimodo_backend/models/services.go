package models

import (
	"database/sql"
	"strings"

	"github.com/bugsnag/bugsnag-go"
)

type Services struct {
	User      UserService
	Address   AddressService
	Cart      CartService
	Mail      MailService
	Product   ProductService
	Cosmetics CosmeticsService
	db        *sql.DB
}

//ServiceConfig is really just a function, but I find using
//types like this are easier to read in my source code.
type ServiceConfig func(*Services) error

//NewServices now will accept a list of config functions to
//run. Each function will accept a pointer to the current
//Service object as its only argument and will edit that
//object inline and return  an error if there is one. Once
//we have run all config we will return the Services object.
func NewServices(cfgs ...ServiceConfig) (*Services, error) {
	var s Services
	for _, cfg := range cfgs {
		if err := cfg(&s); err != nil {
			return nil, err
		}
	}
	return &s, nil
}

func WithDB(dialect, connectionInfo string) ServiceConfig {
	return func(s *Services) error {
		db, err := sql.Open(dialect, connectionInfo)
		if err != nil {
			bugsnag.Notify(err)
			return err
		}
		s.db = db
		return nil
	}
}

func WithUser(hmacKey string) ServiceConfig {
	return func(s *Services) error {
		s.User = NewUserService(s.db, hmacKey)
		return nil
	}
}

func WithProduct() ServiceConfig {
	return func(s *Services) error {
		s.Product = NewProductService(s.db)
		return nil
	}
}
func WithCosmetics() ServiceConfig {
	return func(s *Services) error {
		s.Cosmetics = NewCosmeticsService(s.db)
		return nil
	}
}

func WithAddress() ServiceConfig {
	return func(s *Services) error {
		s.Address = NewAddressService(s.db)
		return nil
	}
}

func WithCart() ServiceConfig {
	return func(s *Services) error {
		s.Cart = NewCartService(s.db)
		return nil
	}
}

func WithMail(appDomain string) ServiceConfig {
	return func(s *Services) error {
		s.Mail = NewMailService(s.db, appDomain)
		return nil
	}
}
func (s *Services) Close() error {
	return s.db.Close()
}

//PublicError interface embeds error interface which allows the
type PublicError interface {
	error
	Public() string
}

type modelError string

func (e modelError) Error() string {
	return string(e)
}

func (e modelError) Public() string {
	s := strings.Replace(string(e), "models: ", "", 1)
	split := strings.Split(s, " ")
	split[0] = strings.Title(split[0])
	return strings.Join(split, " ")
}

const (
	ErrNotFound modelError = "models: resource not found"

	ErrEmailNotFound modelError = "models: email not found"

	ErrPinNotFound modelError = "models: pin not found"

	ErrEmailContentNotFound modelError = "models: email contentnot found"

	ErrIDInvalid modelError = "models: ID provided was invalid"
)
