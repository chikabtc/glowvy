package controllers

import (
	"database/sql"
	"dimodo_backend/models"
	"dimodo_backend/utils"
	"fmt"
	"net/smtp"
	"strings"

	"github.com/bugsnag/bugsnag-go"
)

func (u *User) SendForgotPassword(to_email, return_domain, pin string) error {
	mail_smtp := models.SMTP{Id: 1}
	if err := u.ms.FindSMTP(&mail_smtp); err != nil {
		switch err {
		case sql.ErrNoRows:
			msgError := fmt.Errorf("Send Forgot ErrNoRows: %s", err.Error())
			return msgError
		default:
			msgError := fmt.Errorf("Send Forgot default Error: %s", err.Error())
			return msgError
		}
	}

	mail_smtp.Password = utils.MixDecodeReverse(mail_smtp.Password)
	msg := u.EmailForgotPassword(to_email, return_domain, pin, mail_smtp.Address)
	err := smtp.SendMail(mail_smtp.Host+":"+mail_smtp.Port,
		smtp.PlainAuth("", mail_smtp.Address, mail_smtp.Password, mail_smtp.Host),
		mail_smtp.Address, []string{to_email}, []byte(msg))

	if err != nil {
		bugsnag.Notify(err)
		msg := fmt.Errorf("SMTP Error: %s", err)
		return msg
	}

	return nil
}

func (u *User) EmailForgotPassword(to, return_domain, pin, address string) string {
	mail_template := models.Mail_template{Id: 1}
	if err := u.ms.FindMailTemplate(&mail_template); err != nil {
		switch err {
		case sql.ErrNoRows:
			msgError := fmt.Sprintf("EmailForgotPassword ErrNoRows: %s", err.Error())
			fmt.Println(msgError)
		default:
			fmt.Println(err.Error())
		}
	}
	return "From: " + address + "\n" +
		"To: " + to + "\n" +
		"Subject: " + mail_template.Subject + "\n" +
		"MIME-Version: 1.0\n" +
		"Content-Type: text/html; charset=ISO-8859-1\n\n" +
		strings.NewReplacer(
			"${{u.app_domain}}", checkValue("", u.app_domain),
			"${{app_name}}", checkValue("", u.app_name),
			"${{link_action}}", checkValue(return_domain, u.app_domain),
			"${{pin_reset}}", checkValue(pin, ""),
			"${{to_email}}", to).Replace(mail_template.Body)
}

func checkValue(value, null_return string) string {
	if !utils.IsEmpty(value) {
		return value
	}
	return null_return
}
