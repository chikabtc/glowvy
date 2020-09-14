package utils

import (
	"bytes"
	"fmt"
	"net/http"
	"time"

	"github.com/bugsnag/bugsnag-go"
)

type Slack struct {
	live_sales_channel  string
	live_signup_channel string
}

func NewSlackService() *Slack {
	return &Slack{
		live_sales_channel:  "https://hooks.slack.com/services/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",
		live_signup_channel: "https://hooks.slack.com/services/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",
	}
}

//send json
func (s *Slack) UpdateLiveSalesOnSlack(jsonValue []byte) error {

	fmt.Println("UpdateLiveSalesOnSlack url: ", s.live_sales_channel)

	req, _ := http.NewRequest("POST", s.live_sales_channel, bytes.NewBuffer(jsonValue))
	// res, _ := http.Post("POST", s.live_sales_channel, bytes.NewBuffer(jsonValue))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept-Charset", "utf-8")
	// fmt.Println("jsonValue: ", jsonValue)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return err
	}
	defer res.Body.Close()
	return nil
}
func (s *Slack) AlertNewSignUp(jsonValue []byte) error {

	fmt.Println("AlertNewSignUp url: ", s.live_signup_channel)

	req, _ := http.NewRequest("POST", s.live_signup_channel, bytes.NewBuffer(jsonValue))
	// res, _ := http.Post("POST", s.live_sales_channel, bytes.NewBuffer(jsonValue))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept-Charset", "utf-8")
	// fmt.Println("jsonValue: ", jsonValue)
	client := http.Client{Timeout: time.Second * 10}
	res, err := client.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		return err
	}
	defer res.Body.Close()
	return nil
}
