package mail

import (
	"fmt"
	"log"
	"os"

	"github.com/sendgrid/sendgrid-go"
	"github.com/sendgrid/sendgrid-go/helpers/mail"
)

const (
	CEOMail = "parker@dimodo.app"
)

func SendEmail(from, to, content string) error {
	sender := mail.NewEmail("Example User", from)
	subject := "Sending with SendGrid is Fun"
	receiver := mail.NewEmail("Example User", to)

	htmlContent := "<strong>and easy to do anywhere, even with Go</strong>"

	message := mail.NewSingleEmail(sender, subject, receiver, content, htmlContent)
	client := sendgrid.NewSendClient(os.Getenv("SENDGRID_API_KEY"))
	response, err := client.Send(message)
	if err != nil {
		log.Println(err)
	} else {
		fmt.Println(response.StatusCode)
		fmt.Println(response.Body)
		fmt.Println(response.Headers)
	}
	return err
}
