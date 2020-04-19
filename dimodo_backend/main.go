package main

import (
	"dimodo_backend/api"
	"dimodo_backend/crawler"
	"errors"
	"fmt"
	"time"

	"github.com/bugsnag/bugsnag-go"
	"github.com/robfig/cron"
)

func main() {

	bugsnag.Configure(bugsnag.Configuration{
		APIKey: "e01a6cf99f5bdf480b010b80e45f8c66",
		// The import paths for the Go packages containing your source files
		ProjectPackages: []string{"main", "gitlab.com/parkerfreeman/dimodo"},
	})

	c := cron.New()
	crawler := crawler.NewCrawler()

	err := c.AddFunc("0 0 21 * * ?", func() {
		start := time.Now()
		cronMessage := errors.New("   crawling new products...")
		bugsnag.Notify(cronMessage)

		crawler.GetMainProducts()
		crawler.AddNewProductsByCategories()
		elapsed := time.Since(start)

		crawlTime := fmt.Errorf("crawling 1500 products took %s", elapsed)
		bugsnag.Notify(crawlTime)
	})
	if err != nil {
		bugsnag.Notify(err)
	}

	api := api.NewAPI()
	api.Run()

}
