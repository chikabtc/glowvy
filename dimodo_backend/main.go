package main

import (
	"dimodo_backend/api"
	"dimodo_backend/crawler"

	"github.com/bugsnag/bugsnag-go"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
)

func main() {

	bugsnag.Configure(bugsnag.Configuration{
		APIKey: "e01a6cf99f5bdf480b010b80e45f8c66",
		// The import paths for the Go packages containing your source files
		ProjectPackages: []string{"main", "gitlab.com/parkerfreeman/dimodo"},

		NotifyReleaseStages: []string{"production"},
	})

	crawler := crawler.NewCrawler()
	api := api.NewAPI(crawler)
	// cronServices := cronJobs.NewCronServices(crawler, crawler.DB)

	// cronServices.Run()
	api.Run()

}
