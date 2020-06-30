package translate

import (
	"context"
	"fmt"

	translate "cloud.google.com/go/translate/apiv3"
	"github.com/bugsnag/bugsnag-go"
	translatepb "google.golang.org/genproto/googleapis/cloud/translate/v3"
)

const (
	ggcProjectID = "dimodo-1585384547888"
	Ko           = "ko"
	Vi           = "vi"
	En           = "en-US"
)

type Translator struct {
	googleTranslate *translate.TranslationClient
}

// func TranslateWebPage(sourceLang, targetLang, text string) error {
// 	ctx := context.Background()
// 	client, err := translate.NewTranslationClient(ctx)
// 	if err != nil {
// 		return fmt.Errorf("NewTranslationClient: %v", err)
// 	}
// 	defer client.Close()

// 	req := &translatepb.TranslateTextRequest{
// 		Parent:             fmt.Sprintf("projects/%s/locations/global", ggcProjectID),
// 		SourceLanguageCode: sourceLang,
// 		TargetLanguageCode: targetLang,
// 		MimeType:           "text/html", // Mime types: "text/plain", "text/html"
// 		Contents:           []string{text},
// 	}

// 	resp, err := client.TranslateText(ctx, req)
// 	if err != nil {
// 		return fmt.Errorf("TranslateText: %v", err)
// 	}

// 	// Display the translation for each input text provided
// 	for _, translation := range resp.GetTranslations() {
// 		fmt.Println("Translated text: \n", translation.GetTranslatedText())
// 	}
// 	return nil
// }

func NewTranslator() (*Translator, error) {
	ctx := context.Background()
	client, err := translate.NewTranslationClient(ctx)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Printf("ggc unavailble to create Translator: %v \n", err)
		return nil, fmt.Errorf("NewTranslator: %v", err)
	}
	defer client.Close()
	return &Translator{
		googleTranslate: client,
	}, err
}

//if papago translation fails then try google translation
func TranslateText(sourceLang, targetLang, text string) (string, error) {
	if text == "" {
		return "", nil
	}
	var result string
	ctx := context.Background()
	client, err := translate.NewTranslationClient(ctx)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Printf("NewTranslationClient: %v \n", err)
		return "", fmt.Errorf("NewTranslationClient: %v", err)
	}
	defer client.Close()
	req := &translatepb.TranslateTextRequest{
		Parent:             fmt.Sprintf("projects/%s/locations/global", ggcProjectID),
		SourceLanguageCode: sourceLang,
		TargetLanguageCode: targetLang,
		MimeType:           "text/plain", // Mime types: "text/plain", "text/html"
		Contents:           []string{text},
	}

	resp, err := client.TranslateText(ctx, req)
	if err != nil {
		bugsnag.Notify(err)
		fmt.Printf("resp, err := client.TranslateText(ctx, req): %v \n", err)

		return "", fmt.Errorf("TranslateText: %v", err)
	}
	// Display the translation for each input text provided
	for _, translation := range resp.GetTranslations() {
		// fmt.Println("ggcTranslate result: \n", translation.GetTranslatedText())
		result = translation.GetTranslatedText()

		return result, nil
	}

	if result == " " || len(result) < 4 || result == "[" {
		fmt.Println("ggTranslate couldn't translate, now trying ppg translate")

		return "", nil

		// result, err = PpgTranslateText(sourceLang, targetLang, text)
		// fmt.Println("pgg translated: ", result)
		// if err != nil {
		// 	bugsnag.Notify(err)
		// 	fmt.Println("err: ", err)
		// }
	}
	fmt.Println("google translate reuslt: ", result)
	return result, err

}

func (t *Translator) TranslateHTML(sourceLang, targetLang, text string) (string, error) {
	ctx := context.Background()
	client, err := translate.NewTranslationClient(ctx)
	if err != nil {
		bugsnag.Notify(err)
		return "", fmt.Errorf("NewTranslationClient: %v", err)
	}
	req := &translatepb.TranslateTextRequest{
		Parent:             fmt.Sprintf("projects/%s/locations/global", ggcProjectID),
		SourceLanguageCode: sourceLang,
		TargetLanguageCode: targetLang,
		MimeType:           "text/html", // Mime types: "text/plain", "text/html"
		Contents:           []string{text},
	}

	resp, err := client.TranslateText(ctx, req)
	if err != nil {
		bugsnag.Notify(err)
		return "", fmt.Errorf("TranslateText: %v", err)
	}

	// Display the translation for each input text provided
	for _, translation := range resp.GetTranslations() {
		// fmt.Println("Translated text: \n", translation.GetTranslatedText())
		return translation.GetTranslatedText(), nil
	}

	return "", err
}
