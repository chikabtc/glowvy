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

	err = c.AddFunc("0 0 5 * * ?", func() {
		start := time.Now()
		cronMessage := errors.New("   crawling new products...")
		bugsnag.Notify(cronMessage)

		err := crawler.GetMainProducts()
		if err != nil {
			bugsnag.Notify(cronMessage)

		}
		err = crawler.AddNewProductsByCategories()
		if err != nil {
			bugsnag.Notify(cronMessage)

		}
		elapsed := time.Since(start)

		crawlTime := fmt.Errorf("crawling 1000 products took %s", elapsed)
		bugsnag.Notify(crawlTime)
	})
	if err != nil {
		bugsnag.Notify(err)
	}

	c.Start()

	api.Run()

}
