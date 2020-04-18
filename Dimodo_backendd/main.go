package main

import (
	"dimodo_backend/api"
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
	// crawler := crawler.NewCrawler()

	err := c.AddFunc("0 0 13 * * ?", func() {
		fmt.Println(time.Now().Format(time.RFC850))
		cronMessage := errors.New("   crawling new products...")

		bugsnag.Notify(cronMessage)

		// fmt.Println(("adding new "))
		// get main products
		// crawler.GetMainProducts()
		// // new popular products by category
		// crawler.AddNewProductsByCategories()
	})
	if err != nil {
		bugsnag.Notify(err)

	}
	c.Start()

	api := api.NewAPI()
	api.Run()
}
