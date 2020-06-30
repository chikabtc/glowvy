package crawler

import (
	"context"
	"log"

	"github.com/chromedp/chromedp"
)

func GetProductMetaInfo(productTitle string) {
	searchURL := "https://search.shopping.naver.com/search/all?frm=NVSHATC&pagingIndex=1&pagingSize=40&productSet=total&query=" +
		productTitle +
		"&sort=rel&timestamp=&viewType=list"
	ctx, cancel := chromedp.NewContext(context.Background())
	defer cancel()

	var title string
	err := chromedp.Run(ctx,
		chromedp.Navigate(searchURL),
		chromedp.WaitVisible("list_basis"),
		chromedp.Value(`.list_basis .basicList_link__1MaTN`, &title),
	)

	if err != nil {
		log.Fatal(err)
	}

	log.Printf("title of product", title)

}
