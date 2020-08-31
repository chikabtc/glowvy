package models

import (
	"database/sql"

	"github.com/gchaincl/dotsql"
)

//UserService is a set of methods used to manipulate and work with account model
type MailService interface {
	CreateEmail(subject *Subject) error
	FindSMTP(mail_smtp *SMTP) error
	FindMailTemplate(mail_template *Mail_template) error
}

type mailService struct {
	DB  *sql.DB
	dot *dotsql.DotSql

	MailService
}

func NewMailService(db *sql.DB, appDomain string) MailService {
	mailDot, _ := dotsql.LoadFromFile("sql/mail.pgsql")

	return &mailService{
		DB:  db,
		dot: mailDot,
	}
}

var mail MailService = &mailService{}

type Subject struct {
	Id             int    `json:"id"`
	Email          string `json:"email"`
	Email_verified bool   `json:"email_verified"`
}

type Mail_template struct {
	Id      int    `json:"id,omitempty"`
	Subject string `json:"subject,omitempty"`
	Body    string `json:"body,omitempty"`
}

type SMTP struct {
	Id       int    `json:"id,omitempty"`
	Address  string `json:"name,omitempty"`
	Host     string `json:"active,omitempty"`
	Password string `json:"updated_at,omitempty"`
	Port     string `json:"created_at,omitempty"`
}

func (m *mailService) CreateEmail(subject *Subject) error {
	row, err := m.dot.QueryRow(m.DB, "QueryEmailSubject", subject.Email)
	row.Scan(&subject.Id)
	return err
}

func (m *mailService) FindSMTP(mail_smtp *SMTP) error {
	row, err := m.dot.QueryRow(m.DB, "QuerySMTP", mail_smtp.Id)
	row.Scan(
		&mail_smtp.Id,
		&mail_smtp.Address,
		&mail_smtp.Host,
		&mail_smtp.Password,
		&mail_smtp.Port)
	return err
}
func (m *mailService) FindMailTemplate(mail_template *Mail_template) error {
	row, err := m.dot.QueryRow(m.DB, "QueryMailTemplate", mail_template.Id)
	row.Scan(
		&mail_template.Id,
		&mail_template.Subject,
		&mail_template.Body)
	return err
}
