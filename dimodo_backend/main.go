package main

import (
	"dimodo_backend/api"
	"dimodo_backend/crawler"
	"errors"
	"fmt"
	"time"

	"github.com/bugsnag/bugsnag-go"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
	"github.com/robfig/cron"
)

func main() {

	bugsnag.Configure(bugsnag.Configuration{
		APIKey: "e01a6cf99f5bdf480b010b80e45f8c66",
		// The import paths for the Go packages containing your source files
		ProjectPackages: []string{"main", "gitlab.com/parkerfreeman/dimodo"},

		NotifyReleaseStages: []string{"production"},
	})

	c := cron.New()
	crawler := crawler.NewCrawler()
	api := api.NewAPI(crawler)

	err := c.AddFunc("0 0 3 * * ?", func() {
		start := time.Now()
		cronMessage := errors.New("   updating products...")
		bugsnag.Notify(cronMessage)
		err := crawler.UpdateProducts()
		if err != nil {
			bugsnag.Notify(cronMessage)
		}

		elapsed := time.Since(start)

		crawlTime := fmt.Errorf("updating all products prices %s", elapsed)
		bugsnag.Notify(crawlTime)
	})
	if err != nil {
		bugsnag.Notify(err)
	}

	// client := search.NewClient("50G6MO803G", "ab5eb7ec7552bb7865f3819a2b08f462")
	// index := client.InitIndex("products")

	// allProducts, err := api.Cs.ProductC.Ps.GetAllProducts()
	// fmt.Println("length: ", len(allProducts))
	// for _, product := range allProducts {
	// 	_, err = index.SaveObjects(product, opt.AutoGenerateObjectIDIfNotExist(true))
	// 	if err != nil {
	// 		fmt.Println("fail to save to agolio: ", err, "productId: ", product.Sid)
	// 	}
	// }

	// err = c.AddFunc("0 0 5 * * ?", func() {
	// 	start := time.Now()
	// 	cronMessage := errors.New("   crawling new products...")
	// 	bugsnag.Notify(cronMessage)

	// 	err := crawler.GetMainProducts()
	// 	if err != nil {
	// 		bugsnag.Notify(cronMessage)

	// 	}
	// 	err = crawler.AddNewProductsByCategories()
	// 	if err != nil {
	// 		bugsnag.Notify(cronMessage)

	// 	}
	// 	elapsed := time.Since(start)

	// 	crawlTime := fmt.Errorf("crawling 1000 products took %s", elapsed)
	// 	bugsnag.Notify(crawlTime)
	// })
	if err != nil {
		bugsnag.Notify(err)
	}
	// crawler.TranslateTags()
	c.Start()
	api.Run()

}
