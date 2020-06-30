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
		ReleaseStage:    "development",

		NotifyReleaseStages: []string{"production"},
	})

	crawler := crawler.NewCrawler()
	api := api.NewAPI(crawler)
	// api.Cs.ProductC.Cs.UpdateBrandsName()
	// time.Sleep(2 * time.Second)

	api.Cs.ProductC.Ps.TranslateAllCosmetics()
	// err := crawler.CollectAllOptions()
	// fmt.Println(err)
	// cronServices.Run()
	// all creams
	// if err := crawler.GetGlowPickProductsByRank(2, 4, 25, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 4, 25, "sensitive", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 4, 25, "dry", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 4, 25, "oily", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// // cleansers
	// if err := crawler.GetGlowPickProductsByRank(2, 32, 25, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 32, 25, "sensitive", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 32, 25, "dry", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 32, 25, "oil", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	//serum
	// if err := crawler.GetGlowPickProductsByRank(2, 3, 25, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }

	// if err := crawler.GetGlowPickProductsByRank(2, 3, 25, "sensitive", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 3, 25, "dry", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(2, 3, 25, "oily", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// //Whitening serum
	// if err := crawler.GetGlowPickProductsByRank(3, 16, 25, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(3, 16, 25, "sensitive", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(3, 16, 25, "dry", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(3, 16, 25, "oily", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// //Whitening cream
	// if err := crawler.GetGlowPickProductsByRank(3, 25, 25, "all", "rank"); err != nil {
	// 	fmt.Println(err)
	// }

	// if err := crawler.GetGlowPickProductsByRank(3, 25, 25, "sensitive", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(3, 25, 25, "oily", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	// if err := crawler.GetGlowPickProductsByRank(3, 25, 25, "dry", "rank"); err != nil {
	// 	fmt.Println(err)
	// }
	api.Run()

}
