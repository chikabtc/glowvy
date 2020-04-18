package translate

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"

	"github.com/bugsnag/bugsnag-go"
)

const (
	ppGoAPIID  = "vlnlz736kx"
	ppGoAPIKey = "UClKDfdh4YpgI7qNTCfHc7rfyQqioQjDILXVUZww"
	ppgURL     = "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation"
)

type Translation struct {
	Message Message `json:"message"`
}

type Message struct {
	Type    string `json:"@type"`
	Service string `json:"@service"`
	Version string `json:"@version"`
	Result  Result `json:"result"`
}

type Result struct {
	SrcLangType    string `json:"srcLangType"`
	TarLangType    string `json:"tarLangType"`
	TranslatedText string `json:"translatedText"`
}

func PpgTranslateText(sourceLang, targetLang, text string) (string, error) {
	values := map[string]string{"source": sourceLang, "target": targetLang, "text": text}
	jsonValue, _ := json.Marshal(values)

	form := url.Values{}
	form.Set("source", sourceLang)
	form.Set("target", targetLang)
	form.Set("text", text)
	req, err := http.NewRequest("POST", ppgURL, bytes.NewBuffer(jsonValue))
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("ppg translate request error", err)
		return "", err
	}
	req.PostForm = form
	req.Header.Add("X-NCP-APIGW-API-KEY-ID", ppGoAPIID)
	req.Header.Add("X-NCP-APIGW-API-KEY", ppGoAPIKey)
	req.Header.Add("Content-Type", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("http.DefaultClient.Do(req) error", err)
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("ioutil.ReadAll(resp.Body) error", err)
	}

	var translation Translation
	// fmt.Println(body)
	err = json.Unmarshal(body, &translation)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Println("json.Unmarshal(body, &translation)error", err)

		fmt.Println("Error")
	}

	return translation.Message.Result.TranslatedText, nil
}
